// Updated features/auth/presentation/pages/register_page.dart
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

  String _selectedRole = 'pupil'; // Changed default to parent
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Your Account',
        centerTitle: false,
        showBackButton: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileCompletionRequired) {
            // Navigate to appropriate profile completion screen based on role
            if (state.user.role == 'pupil') {
              context.go(RouteNames.completeProfilePupil);
            } else if (state.user.role == 'coach') {
              // Show success message for coach (profile already created, pending verification)

              context.go(RouteNames.completeProfileCoach);
              // context.go(RouteNames.home);
            }
          } else if (state is AuthAuthenticated) {
            // context.go(RouteNames.home);
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
                    SizedBox(height: SizeConfig.scaleHeight(20)),

                    // First Name
                    CustomTextFieldFactory.name(
                      controller: firstNameCtrl,
                      label: 'First Name',
                      placeholder: 'Enter First Name',
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(20)),

                    // Last Name
                    CustomTextFieldFactory.name(
                      controller: lastNameCtrl,
                      label: 'Last Name',
                      placeholder: 'Enter Last Name',
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(20)),

                    // Email
                    CustomTextFieldFactory.email(
                      controller: emailCtrl,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(12)),

                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Parent'),
                          subtitle: const Text(
                            'Create accounts for your children',
                          ),
                          value: 'pupil',
                          groupValue: _selectedRole,
                          onChanged: (value) =>
                              setState(() => _selectedRole = value!),
                        ),
                        RadioListTile<String>(
                          title: const Text('Coach'),
                          subtitle: const Text(
                            'Teach and guide junior golfers',
                          ),
                          value: 'coach',
                          groupValue: _selectedRole,
                          onChanged: (value) =>
                              setState(() => _selectedRole = value!),
                        ),
                      ],
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
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(32)),

                    // Register button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleRegister,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Account'),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        TextButton(
                          onPressed: () => context.go(RouteNames.login),
                          child: const Text('Sign In'),
                        ),
                      ],
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
