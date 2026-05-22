import 'package:doctor/Core/Bloc/Login_bloc.dart';
import 'package:doctor/Core/Controller.dart/themecontroller.dart';
import 'package:doctor/Core/Theme/color_app.dart';
import 'package:doctor/Core/widgets/custom_button.dart';
import 'package:doctor/Core/widgets/custom_text_form_field_core.dart';
import 'package:doctor/Presentation/AuthScreen/Signup.dart';
import 'package:doctor/Presentation/HomeScreen/doctor_home_sc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ForgotPasswordSC.dart';

class Loginsc extends StatefulWidget {
  const Loginsc({super.key});

  @override
  State<Loginsc> createState() => _LoginscState();
}

class _LoginscState extends State<Loginsc> {
  final ThemeController themeController = Get.put(ThemeController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateByRole(String role) {
    switch (role) {
      case 'Admin':
      case 'Doctor':
      case 'Staff':
      default:
        Get.offAll(() => const Doctorhomesc());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc()..add(LoadLogin()),
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/background/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),

            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.success && state.user != null) {
                  _navigateByRole(state.user!.role);
                } else if (state.status == LoginStatus.failure &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: state.isLoading ? 0 : 1,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60.h),

                            // Logo
                            Image.asset(
                              'assets/images/logo/logo.png',
                              height: 80.h,
                            ),
                            SizedBox(height: 12.h),

                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Sign in to continue',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 36.h),

                            // Email
                            CustomTextFormFieldCore(
                              label: 'Email',
                              hint: 'doctor@clinic.com',
                              icon: 'assets/Icons/Patient/email.png',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              fieldFillColor: Colors.white,
                              lableStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8.w,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Email is required';
                                if (!v.contains('@'))
                                  return 'Enter a valid email';
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Password
                            _PasswordField(
                              controller: _passwordController,
                              obscureText: state.obscureText,
                              onToggle: () =>
                                  context.read<LoginBloc>().add(TogglePassword()),
                              validator: (v) =>
                              v == null || v.isEmpty ? 'Password is required' : null,
                            ),
                            SizedBox(height: 10.h),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Get.to(() => const ForgotPasswordSC()),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: ColorApp.textColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Login button
                            _LoginButton(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                            SizedBox(height: 24.h),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13.sp),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(() => const SignupSC()),
                                  child: Text(
                                    'Join us',
                                    style: TextStyle(
                                      color: ColorApp.textColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading overlay
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.status == LoginStatus.loading) {
                  return Container(
                    color: Colors.black38,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Login Button ───────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;
        return CustomButton(
          onPressed: isLoading
              ? null
              : () {
            if (formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginSubmitted(
                email: emailController.text,
                password: passwordController.text,
              ));
            }
          },
          text: isLoading ? 'Signing in...' : 'Login',
        );
      },
    );
  }
}

// ── Password Field (matches CustomTextFormFieldCore style) ─────────────────

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PASSWORD',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8.w,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          cursorColor: ColorApp.textColor,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(fontSize: 14.sp, color: ColorApp.hintColor),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Image.asset(
                  'assets/Icons/Eye.png',
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF0F6E56), width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }
}
