import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../route/routes_names.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/text_field_component.dart';
import '../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignInRequested(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    context.push(RouteNames.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.isCoach) {
            context.go(RouteNames.coachHome); // ✅ verified coach
          } else {
            context.go(RouteNames.pupilHome);
          }
        } else if (state is AuthCoachPendingVerification) {
          context.go(RouteNames.pendingVerification);
        } else if (state is AuthProfileCompletionRequired) {
          state.user.isCoach
              ? context.go(RouteNames.completeProfileCoach)
              : context.go(RouteNames.completeProfilePupil);
        } else if (state is AuthGuestSignedIn) {
          context.go(RouteNames.guestHome);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppScaffold.form(
          title: 'Log in',
          levelType: LevelType.redLevel,
          scrollable: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.scaleHeight(20)),

                          CustomTextFieldFactory.email(
                            controller: emailCtrl,
                            levelType: LevelType.redLevel,
                            validator: (v) {
                              if ((v ?? '').isEmpty)
                                return 'Please enter your email';
                              if (!(v ?? '').contains('@'))
                                return 'Invalid email';
                              return null;
                            },
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(20)),

                          CustomTextFieldFactory.password(
                            controller: passwordCtrl,
                            levelType: LevelType.redLevel,
                            obscureText: _obscurePassword,
                            onToggleObscurity: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            validator: (v) => (v ?? '').isEmpty
                                ? 'Please enter your password'
                                : null,
                          ),

                          const Spacer(),

                          CustomButtonFactory.primary(
                            text: 'Log in',
                            onPressed: isLoading ? null : _handleLogin,
                            isLoading: isLoading,
                            levelType: LevelType.redLevel,
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(16)),

                          CustomButtonFactory.text(
                            text: 'Forgot password?',
                            onPressed: _handleForgotPassword,
                            levelType: LevelType.redLevel,
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(20)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
