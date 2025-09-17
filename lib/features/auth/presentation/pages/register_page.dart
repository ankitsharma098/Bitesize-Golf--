import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/custom_app_bar.dart';
import '../../../components/utils/custom_radio.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String _selectedRole = 'pupil';
  bool _agreeToTerms = false;
  bool _obscurePass = true;

  @override
  void initState() {
    _initializeUserData();
    super.initState();
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthProfileCompletionRequired) {
      if (authState.user.firstName != null && authState.user.lastName != null) {
        firstNameCtrl.text = authState.user.firstName!;
        lastNameCtrl.text = authState.user.lastName!;
      }
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    // Now you can simply use this in your RegisterPage:

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileCompletionRequired) {
          if (state.user.role == 'pupil') {
            context.go(RouteNames.completeProfilePupil);
          } else if (state.user.role == 'coach') {
            context.go(RouteNames.completeProfileCoach);
          }
        } else if (state is AuthAuthenticated) {
          final isPupil = state.user.isPupil;
          isPupil
              ? context.go(RouteNames.pupilHome)
              : context.go(RouteNames.coachHome);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        // NOW THIS WILL WORK WITHOUT OVERFLOW ERRORS
        return AppScaffold.form(
          title: 'Create Your Account',
          showBackButton: true,
          scrollable:
              true, // This now works perfectly with the fixed CustomScaffold
          levelType: LevelType.redLevel,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // First Name
                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  levelType: LevelType.redLevel,
                  label: 'First Name',
                  placeholder: 'Enter First Name',
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // Last Name
                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  levelType: LevelType.redLevel,
                  label: 'Last Name',
                  placeholder: 'Enter Last Name',
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // Email
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

                // Password
                CustomTextFieldFactory.password(
                  controller: passwordCtrl,
                  obscureText: _obscurePass,
                  levelType: LevelType.redLevel,
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

                // Role selector
                const Text(
                  'Choose your role*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: SizeConfig.scaleHeight(12)),
                CustomRadioGroup<String>(
                  options: [
                    RadioOption(value: 'pupil', label: 'Pupil'),
                    RadioOption(value: 'coach', label: 'Coach'),
                  ],
                  groupValue: _selectedRole,
                  onChanged: (value) => setState(() => _selectedRole = value!),
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (v) =>
                          setState(() => _agreeToTerms = v ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _agreeToTerms = !_agreeToTerms),
                        child: const Text(
                          'I agree to the Terms and Conditions',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.scaleHeight(32)),

                CustomButtonFactory.primary(
                  text: 'Register',
                  onPressed: isLoading ? null : _handleRegister,
                  isLoading: isLoading,
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                ),

                SizedBox(height: SizeConfig.scaleHeight(8)),

                // Login link
                Center(child: const Text('Already have an account? ')),
                SizedBox(height: SizeConfig.scaleHeight(5)),

                CustomButtonFactory.text(
                  onPressed: () => context.go(RouteNames.login),
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                  text: 'Log In',
                ),

                // Add bottom padding for safe scrolling
                SizedBox(height: SizeConfig.scaleHeight(32)),
              ],
            ),
          ),
        );
      },
    );
  }
}
