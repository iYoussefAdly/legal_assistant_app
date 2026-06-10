import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/router/app_router.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/core/utils/helpers/show_snack_bar.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_state.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/custom_text_field.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nationalIdController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nationalIdController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.chat);
          showSnackBar(context, 'Login Successful. Welcome!', Colors.green);
        } else if (state is LoginFailure) {
          showSnackBar(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeader(text: 'Sign in to continue'),
                      const SizedBox(height: 64),
                      CustomTextField(
                        hintText: 'Enter your National ID',
                        isItPassword: false,
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your National ID';
                          }
                          if (value.length != 14) {
                            return 'National ID must be 14 digits';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'National ID must contain only digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Enter your password',
                        isItPassword: true,
                        controller: _passwordController,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? 'Password is required'
                                : null,
                      ),
                      const SizedBox(height: 64),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.signUp),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: AppStyles.styleRegular18
                                      .copyWith(color: const Color(0xFFF6D3D3)),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppStyles.styleRegular18
                                      .copyWith(color: Colors.red),
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
                                color: Color(0xffAF63E8))
                            : CustomButton(
                                buttonName: 'Login',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login(
                                          _nationalIdController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
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
    );
  }
}
