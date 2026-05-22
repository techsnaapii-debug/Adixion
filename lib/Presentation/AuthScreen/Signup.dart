
import 'package:doctor/Core/Theme/color_app.dart';
import 'package:doctor/Core/widgets/custom_button.dart';
import 'package:doctor/Core/widgets/custom_text_form_field_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Core/Bloc/Signup_bloc.dart';

class SignupSC extends StatefulWidget {
  const SignupSC({super.key});

  @override
  State<SignupSC> createState() => _SignupSCState();
}

class _SignupSCState extends State<SignupSC> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
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

            BlocConsumer<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state.status == SignupStatus.success) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r)),
                      title: const Text('Registration Submitted'),
                      content: Text(
                        state.successMessage ??
                            'Your account is pending admin approval.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.back();
                          },
                          child: Text(
                            'Back to Login',
                            style: TextStyle(color: ColorApp.buttomColor),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state.status == SignupStatus.failure &&
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
                final bloc = context.read<SignupBloc>();

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // Back button
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 18.sp),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Fill in your details to get started',
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white70),
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // First + Last name
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormFieldCore(
                                  label: 'First Name',
                                  hint: 'Amit',
                                  icon: 'assets/images/Icons/Patient/Add/e.png',
                                  widthIcon: 16.w,
                                  heightIcon: 16.h,
                                  controller: _firstNameCtrl,
                                  fieldFillColor: Colors.white,
                                  lableStyle: _labelStyle,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomTextFormFieldCore(
                                  label: 'Last Name',
                                  hint: 'Sharma',
                                  icon: 'assets/images/Icons/Patient/Add/e.png',
                                  widthIcon: 16.w,
                                  heightIcon: 16.h,
                                  controller: _lastNameCtrl,
                                  fieldFillColor: Colors.white,
                                  lableStyle: _labelStyle,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),

                          CustomTextFormFieldCore(
                            label: 'Email',
                            hint: 'doctor@clinic.com',
                            icon: 'assets/Icons/Patient/email.png',
                            widthIcon: 18.w,
                            heightIcon: 18.h,
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            fieldFillColor: Colors.white,
                            lableStyle: _labelStyle,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                          SizedBox(height: 14.h),

                          CustomTextFormFieldCore(
                            label: 'Phone (optional)',
                            hint: '9876543210',
                            icon: 'assets/images/Icons/Patient/Add/p.png',
                            widthIcon: 16.w,
                            heightIcon: 16.h,
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            fieldFillColor: Colors.white,
                            lableStyle: _labelStyle,
                          ),
                          SizedBox(height: 14.h),

                          // Password with toggle
                          _PasswordField(
                            controller: _passwordCtrl,
                            obscureText: state.obscureText,
                            onToggle: () => bloc.add(SignupTogglePassword()),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (v.length < 6) return 'Min 6 characters';
                              return null;
                            },
                          ),
                          SizedBox(height: 14.h),

                          // Role selector
                          Text(
                            'ROLE',
                            style: _labelStyle,
                          ),
                          SizedBox(height: 8.h),
                          _RoleSelector(
                            selected: state.role,
                            onChanged: (r) => bloc.add(SignupRoleChanged(r)),
                          ),
                          SizedBox(height: 30.h),

                          // Submit
                          _SignupButton(
                            formKey: _formKey,
                            firstNameCtrl: _firstNameCtrl,
                            lastNameCtrl: _lastNameCtrl,
                            emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl,
                            passwordCtrl: _passwordCtrl,
                          ),
                          SizedBox(height: 20.h),

                          Center(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13.sp),
                                  children: [
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: ColorApp.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading overlay
            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                if (state.status == SignupStatus.loading) {
                  return Container(
                    color: Colors.black38,
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
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

  TextStyle get _labelStyle => TextStyle(
    fontSize: 12.sp,
    color: Colors.white70,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8.w,
  );
}

// ── Role Selector ──────────────────────────────────────────────────────────

class _RoleSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;

  const _RoleSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Doctor', 'Staff'].map((role) {
        final isSelected = selected == role;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(role),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: role == 'Doctor' ? 10.w : 0),
              height: 50.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorApp.buttomColor
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? ColorApp.buttomColor
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Center(
                child: Text(
                  role,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : ColorApp.labelTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Submit Button ──────────────────────────────────────────────────────────

class _SignupButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passwordCtrl;

  const _SignupButton({
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passwordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        final isLoading = state.status == SignupStatus.loading;
        return CustomButton(
          onPressed: isLoading
              ? null
              : () {
            if (formKey.currentState!.validate()) {
              context.read<SignupBloc>().add(SignupSubmitted(
                firstName: firstNameCtrl.text,
                lastName: lastNameCtrl.text,
                email: emailCtrl.text,
                phone: phoneCtrl.text,
                password: passwordCtrl.text,
              ));
            }
          },
          text: isLoading ? 'Creating Account...' : 'Create Account',
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
