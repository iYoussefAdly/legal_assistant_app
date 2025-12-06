import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/core/utils/helpers/show_snack_bar.dart';
import 'package:legal_assistant_app/presentation/views/chat_view.dart';
import 'package:legal_assistant_app/presentation/views/sign_up_view.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_text_field.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/auth_header.dart';
import '../../../../logic/cubit/login_cubit.dart';
import '../../../../logic/states/login_state.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatView()),
            );
            showSnackBar(context, "Login Successful. Welcome!", Colors.green);
          } else if (state is LoginFailure) {
            showSnackBar(context, state.errorMessage, Colors.red);
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.5),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AuthHeader(text: 'Sign in to continue'),
                        const SizedBox(height: 64),
                        CustomTextField(
                          hintText: "Enter your National ID",
                          isItPassword: false,
                          controller: cubit.nationalIdController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your National ID';
                            }
                            if (value.length != 14) {
                              return "National ID must be 14 digits";
                            }
                            final nIdRegex = RegExp(r'^[0-9]+$');
                            if (!nIdRegex.hasMatch(value)) {
                              return "National ID must contain only digits (0-9)";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: "enter your password",
                          isItPassword: true,
                          controller: cubit.passwordController,
                          validator: (value) =>
                              value!.isEmpty ? 'Password is required' : null,
                        ),
                        const SizedBox(height: 64),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpView(),
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: AppStyles.styleRegular18.copyWith(
                                      color: Color(0xFFF6D3D3),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign Up",
                                    style: AppStyles.styleRegular18.copyWith(
                                      color: const Color(0xffAF63E8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.center,
                          child: state is LoginLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xffAF63E8),
                                )
                              : CustomButton(
                                  buttonName: "Login",
                                  onTap: () => cubit.login(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
