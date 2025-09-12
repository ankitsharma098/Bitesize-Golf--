import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/custom_app_bar.dart';
import '../../../components/utils/size_config.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthResetPasswordRequested(email: emailCtrl.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CustomAppBar(
        title: 'Forgot Password',
        levelType: LevelType.redLevel,
        centerTitle: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSent) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Check your email! 📧'),
                content: Text(
                  'We have sent password-reset instructions to ${state.email}.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
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

                    Text(
                      'Enter your email address below and we\'ll send you '
                      'instructions to reset your password.',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleWidth(16),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(32)),

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
                    SizedBox(height: SizeConfig.scaleHeight(32)),

                    /* ---- Send Reset Link ---- */
                    CustomButtonFactory.primary(
                      text: 'Send Reset Link',
                      onPressed: isLoading ? null : _handleResetPassword,
                      levelType: LevelType.redLevel,
                      isLoading: isLoading,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    /* ---- Back to Login ---- */
                    Center(child: const Text('Remembered your password?')),
                    CustomButtonFactory.text(
                      text: 'Log in',
                      onPressed: () => context.pop(),
                      levelType: LevelType.redLevel,
                      width: 26,
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
