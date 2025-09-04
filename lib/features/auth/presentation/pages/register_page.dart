import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/custom_app_bar.dart';
import '../../../components/utils/custom_radio.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  /* ---------- controllers ---------- */
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  /* ---------- local state ---------- */
  String _selectedRole = 'pupil';
  bool _agreeToTerms = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  /* ---------- handlers ---------- */
  void _handleRegister() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      context.read<AuthBloc>().add(
        AuthSignUpRequested(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
          role: _selectedRole,
          firstName: firstNameCtrl.text.trim(),
          lastName: lastNameCtrl.text.trim(),
        ),
      );
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms')),
      );
    }
  }

  void _handleRoleChange(String role) => setState(() => _selectedRole = role);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* ---------- app-bar (same style as LoginPage) ---------- */
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CustomAppBar(
        title: 'Create Your Account',
        levelType: LevelType.redLevel,
        centerTitle: false,
        showBackButton: true,
      ),

      /* ---------- body ---------- */
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            state.user.role == 'coach'
                ? context.go(RouteNames.completeProfileCoach)
                : context.go(RouteNames.completeProfilePupil);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFieldFactory.name(
                      controller: firstNameCtrl,
                      label: 'First Name',
                      levelType: LevelType.redLevel,
                      placeholder: 'Enter First Name',
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(20)),
                    CustomTextFieldFactory.name(
                      controller: lastNameCtrl,
                      levelType: LevelType.redLevel,
                      label: 'Last Name',
                      placeholder: 'Enter Last Name',
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(20)),

                    /* ---- Email ---- */
                    CustomTextFieldFactory.email(
                      controller: emailCtrl,
                      levelType: LevelType.redLevel,
                      validator: (v) {
                        final val = (v ?? '').trim();
                        if (val.isEmpty) return 'Please enter your email';
                        if (!val.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(20)),

                    /* ---- Password ---- */
                    CustomTextFieldFactory.password(
                      controller: passwordCtrl,
                      levelType: LevelType.redLevel,
                      obscureText: _obscurePass,
                      validator: (v) {
                        final val = (v ?? '').trim();
                        if (val.isEmpty) return 'Enter a password';
                        if (val.length < 6) return 'Min 6 characters';
                        return null;
                      },
                      onToggleObscurity: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(24)),

                    /* ---- Role selector ---- */
                    const Text(
                      'Choose your role*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(12)),
                    CustomRadioGroup<String>(
                      levelType: LevelType.redLevel, // theme colour
                      groupValue: _selectedRole,
                      onChanged: (v) => setState(() => _selectedRole = v!),
                      options: const [
                        RadioOption(value: 'pupil', label: 'Pupil'),
                        RadioOption(value: 'coach', label: 'Coach'),
                      ],
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(24)),

                    /* ---- Terms checkbox ---- */
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (v) =>
                              setState(() => _agreeToTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              /* show terms */
                            },
                            child: Text(
                              'I agree to the Terms and Conditions',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.redDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(32)),

                    /* ---- Register button ---- */
                    CustomButtonFactory.primary(
                      text: 'Register',
                      onPressed: isLoading ? null : _handleRegister,
                      levelType: LevelType.redLevel,
                      isLoading: isLoading,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),
                    Center(child: const Text('Already have an account?')),
                    SizedBox(height: SizeConfig.scaleHeight(8)),
                    CustomButtonFactory.text(
                      text: 'Log in',
                      levelType: LevelType.redLevel,
                      onPressed: () {
                        NavigationService.push(RouteNames.login);
                      },
                      width: SizeConfig.scaleWidth(20),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
