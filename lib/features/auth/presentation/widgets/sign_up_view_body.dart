import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/router/app_router.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/core/utils/helpers/show_snack_bar.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/signup_state.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/gender_drop_down_field.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nationalIdController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nationalIdController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          showSnackBar(context, state.message, Colors.red);
        } else if (state is SignupSuccess) {
          showSnackBar(
            context,
            'Account Created Successfully! Log in to continue.',
            Colors.green,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.signIn);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
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
                      hintText: 'Enter your full name',
                      isItPassword: false,
                      controller: _fullNameController,
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
                      hintText: 'Enter your email',
                      isItPassword: false,
                      controller: _emailController,
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
                      hintText: 'Enter your password',
                      isItPassword: true,
                      controller: _passwordController,
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
                      selectedGender: _selectedGender,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),
                    const SizedBox(height: 64),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.signIn),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: AppStyles.styleRegular18
                                    .copyWith(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Sign in',
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
                      child: state is SignupLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              buttonName: 'Create an account',
                              onTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                context.read<SignupCubit>().signup(
                                      nationalId:
                                          _nationalIdController.text.trim(),
                                      fullName: _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password:
                                          _passwordController.text.trim(),
                                      gender: _selectedGender!,
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
    );
  }
}
