import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/data/models/user_data.dart';
import 'package:legal_assistant_app/logic/cubit/signup_cubit.dart';
import 'package:legal_assistant_app/logic/states/signup_state.dart';
import 'package:legal_assistant_app/presentation/views/chat_view.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_text_field.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/auth_header.dart';

class SignUpViewBody extends StatelessWidget {
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signup Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatView()),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.5),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthHeader(text: 'Sign up'),
                      SizedBox(height: 64),
                      CustomTextField(
                        hintText: "enter your National id",
                        isItPassword: false,
                        controller: nationalIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your National ID';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        hintText: "enter your full name",
                        isItPassword: false,
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        hintText: "enter your email",
                        isItPassword: false,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        hintText: "enter your password",
                        isItPassword: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        hintText: "enter your gender",
                        isItPassword: false,
                        controller: genderController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your gender';
                          }
                        },
                      ),
                      SizedBox(height: 32),
                      Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: Text(
                          "Forget Password?",
                          style: AppStyles.styleRegular14.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignInView();
                                },
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account?",
                                  style: AppStyles.styleRegular18.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "Sign in",
                                  style: AppStyles.styleRegular18.copyWith(
                                    color: Color(0xffAF63E8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      state is SignupLoading
                          ? Center(child: CircularProgressIndicator())
                          : Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                buttonName: "Create an account",
                                onTap: () {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  context.read<SignupCubit>().signup(
                                    UserData(
                                      nationalId: nationalIdController.text,
                                      fullName: fullNameController.text,
                                      email: emailController.text,
                                      passwordHash: passwordController.text,
                                      gender: genderController.text,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
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
