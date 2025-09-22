import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../route/routes_names.dart';
import '../../../core/utils/user_utils.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/text_field_component.dart';
import '../../components/utils/custom_radio.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileCompletionRequired) {
          state.user.isCoach
              ? context.go(RouteNames.completeProfileCoach)
              : context.go(RouteNames.completeProfilePupil);
        } else if (state is AuthAuthenticated) {
          if (state.user.isCoach) {
            context.go(RouteNames.coachHome); // ✅ verified coach
          } else {
            context.go(RouteNames.pupilHome);
          }
        } else if (state is AuthCoachPendingVerification) {
          context.go(RouteNames.pendingVerification);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppScaffold.form(
          title: 'Create Your Account',
          showBackButton: true,
          scrollable: true,
          levelType: LevelType.redLevel,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  label: 'First Name',
                  placeholder: 'Enter First Name',
                  levelType: LevelType.redLevel,
                  validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  label: 'Last Name',
                  placeholder: 'Enter Last Name',
                  levelType: LevelType.redLevel,
                  validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.email(
                  controller: emailCtrl,
                  levelType: LevelType.redLevel,
                  validator: (v) {
                    if ((v ?? '').isEmpty) return 'Please enter email';
                    if (!(v ?? '').contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.password(
                  controller: passwordCtrl,
                  obscureText: _obscurePass,
                  levelType: LevelType.redLevel,
                  validator: (v) {
                    if ((v ?? '').isEmpty) return 'Enter password';
                    if ((v ?? '').length < 6) return 'Min 6 characters';
                    return null;
                  },
                  onToggleObscurity: () =>
                      setState(() => _obscurePass = !_obscurePass),
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),

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

                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (v) =>
                          setState(() => _agreeToTerms = v ?? false),
                    ),
                    const Expanded(
                      child: Text('I agree to the Terms and Conditions'),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.scaleHeight(32)),

                CustomButtonFactory.primary(
                  text: 'Register',
                  onPressed: isLoading ? null : _handleRegister,
                  isLoading: isLoading,
                  levelType: LevelType.redLevel,
                ),
                SizedBox(height: SizeConfig.scaleHeight(12)),

                Center(child: const Text('Already have an account? ')),
                SizedBox(height: SizeConfig.scaleHeight(5)),

                CustomButtonFactory.text(
                  onPressed: () => context.go(RouteNames.login),
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                  text: 'Log In',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
