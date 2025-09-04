import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/custom_app_bar.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';

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
        AuthSignInRequested(emailCtrl.text.trim(), passwordCtrl.text.trim()),
      );
    }
  }

  void _handleGuestLogin() {
    context.read<AuthBloc>().add(AuthGuestSignInRequested());
  }

  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    print("Login Screen");
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CustomAppBar(
        title: 'Log in',
        levelType: LevelType.redLevel,
        centerTitle: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            final isPupil = state.user.isPupil;
            isPupil
                ? context.go(RouteNames.pupilHome)
                : context.go(RouteNames.coachHome);
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

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.scaleHeight(20)),

                          // Email field using factory
                          CustomTextFieldFactory.email(
                            controller: emailCtrl,
                            levelType: LevelType.redLevel,
                            validator: (value) {
                              final v =
                                  value ?? ''; // null becomes empty string
                              if (v.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!v.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: SizeConfig.scaleHeight(20)),

                          // Password field using factory
                          CustomTextFieldFactory.password(
                            controller: passwordCtrl,
                            levelType: LevelType.redLevel,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              final v =
                                  value ?? ''; // null becomes empty string
                              if (v.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onToggleObscurity: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Login button
                    CustomButtonFactory.primary(
                      text: 'Log in',
                      onPressed: isLoading
                          ? null
                          : () {
                              print("Login button pressed outer");
                              if (_formKey.currentState!.validate()) {
                                print("Login button pressed");
                                _handleLogin();
                              }
                            },
                      levelType: LevelType.redLevel,
                      isLoading: isLoading,
                    ),

                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Forgot password text button
                    CustomButtonFactory.text(
                      text: 'Forgot password?',
                      onPressed: _handleForgotPassword,
                      levelType: LevelType.redLevel,
                      size: ButtonSize.medium,
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
