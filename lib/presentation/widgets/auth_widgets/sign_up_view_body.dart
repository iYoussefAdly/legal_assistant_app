import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لاستخدام InputFormatters
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/core/utils/helpers/show_snack_bar.dart';
import 'package:legal_assistant_app/data/models/user_data.dart';
import 'package:legal_assistant_app/logic/cubit/signup_cubit.dart';
import 'package:legal_assistant_app/logic/states/signup_state.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_text_field.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/auth_header.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/gender_drop_down_field.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedGender;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            showSnackBar(context, state.error, Colors.red);
          } else if (state is SignupSuccess) {
            showSnackBar(
              context,
              'Account Created Successfully! Log in to continue.',
              Colors.green,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInView()),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.5),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeader(text: 'Sign up'),
                      const SizedBox(height: 64),
                      CustomTextField(
                        hintText: "Enter your National ID",
                        isItPassword: false,
                        controller: nationalIdController,
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
                        hintText: "Enter your full name",
                        isItPassword: false,
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: "Enter your email",
                        isItPassword: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: "Enter your password",
                        isItPassword: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      GenderDropdownField(
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        selectedGender: selectedGender,
                      ),
                      const SizedBox(height: 64),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SignInView();
                                },
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: AppStyles.styleRegular18.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: "Sign in",
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
                      state is SignupLoading
                          ? const Center(child: CircularProgressIndicator())
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
                                      gender: selectedGender!,
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
