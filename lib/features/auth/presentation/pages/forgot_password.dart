// import 'package:bitesize_golf/core/themes/theme_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../route/routes_names.dart';
// import '../../../components/custom_button.dart';
// import '../../../components/text_field_component.dart';
// import '../../../components/utils/custom_app_bar.dart';
// import '../../../components/utils/size_config.dart';
// import '../../bloc/auth_bloc.dart';
// import '../../bloc/auth_event.dart';
// import '../../bloc/auth_state.dart';
// import '../../../components/custom_scaffold.dart';
//
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailCtrl = TextEditingController();
//
//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     super.dispose();
//   }
//
//   void _handleResetPassword() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//         AuthResetPasswordRequested(email: emailCtrl.text.trim()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold.form(
//       title: 'Forgot Password',
//       showBackButton: true,
//       scrollable: false,
//       levelType: LevelType.redLevel,
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is AuthLoading;
//           final isPasswordResetSent = state is AuthPasswordResetSent;
//
//           return Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Enter your email address below and we\'ll send you instructions to reset your password.',
//                         style: TextStyle(
//                           fontSize: SizeConfig.scaleWidth(16),
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: SizeConfig.scaleHeight(32)),
//
//                       /* ---- Email ---- */
//                       CustomTextFieldFactory.email(
//                         controller: emailCtrl,
//                         levelType: LevelType.redLevel,
//                         validator: (v) {
//                           final val = (v ?? '').trim();
//                           if (val.isEmpty) return 'Please enter your email';
//                           if (!val.contains('@')) return 'Invalid email';
//                           return null;
//                         },
//                       ),
//
//                       SizedBox(height: SizeConfig.scaleHeight(16)),
//
//                       /* ---- Success Message ---- */
//                       if (isPasswordResetSent) ...[
//                         Stack(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(
//                                 SizeConfig.scaleWidth(16),
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade50,
//                                 border: Border.all(
//                                   color: Colors.green.shade300,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Check your email!',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: SizeConfig.scaleWidth(14),
//                                             color: Colors.green.shade800,
//                                           ),
//                                         ),
//                                         Text(
//                                           'We\'ve sent instructions to reset your password.',
//                                           style: TextStyle(
//                                             fontSize: SizeConfig.scaleWidth(12),
//                                             color: Colors.green.shade700,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Positioned(
//                               top: 3,
//                               right: 3,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // Reset the form to allow sending another reset email
//                                   emailCtrl.clear();
//                                   context.read<AuthBloc>().add(
//                                     AuthAppStarted(),
//                                   );
//                                 },
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.green.shade600,
//                                   size: SizeConfig.scaleWidth(20),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: SizeConfig.scaleHeight(32)),
//
//                 /* --- Send Reset Link ---- */
//                 CustomButtonFactory.primary(
//                   text: 'Send Reset Link',
//                   onPressed: (isLoading || isPasswordResetSent)
//                       ? null
//                       : _handleResetPassword,
//                   levelType: LevelType.redLevel,
//                   isLoading: isLoading,
//                 ),
//                 SizedBox(height: SizeConfig.scaleHeight(16)),
//
//                 Center(child: const Text('Remembered your password? ')),
//                 SizedBox(height: SizeConfig.scaleHeight(8)),
//
//                 CustomButtonFactory.text(
//                   text: 'Log in',
//                   onPressed: () => context.pop(),
//                   levelType: LevelType.redLevel,
//                   width: SizeConfig.scaleWidth(26),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
import '../../../components/custom_scaffold.dart';

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
    return AppScaffold.form(
      title: 'Forgot Password',
      showBackButton: true,
      scrollable: false, // We're handling scrolling manually
      levelType: LevelType.redLevel,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final isPasswordResetSent = state is AuthPasswordResetSent;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Form fields section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: SizeConfig.scaleHeight(20)),

                              Text(
                                'Enter your email address below and we\'ll send you instructions to reset your password.',
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

                              SizedBox(height: SizeConfig.scaleHeight(16)),

                              /* ---- Success Message ---- */
                              if (isPasswordResetSent) ...[
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        SizeConfig.scaleWidth(16),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Check your email!',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: SizeConfig.scaleWidth(14),
                                                    color: Colors.green.shade800,
                                                  ),
                                                ),
                                                Text(
                                                  'We\'ve sent instructions to reset your password.',
                                                  style: TextStyle(
                                                    fontSize: SizeConfig.scaleWidth(12),
                                                    color: Colors.green.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 3,
                                      right: 3,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Reset the form to allow sending another reset email
                                          emailCtrl.clear();
                                          context.read<AuthBloc>().add(
                                            AuthAppStarted(),
                                          );
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.green.shade600,
                                          size: SizeConfig.scaleWidth(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),

                          // Spacer to push buttons to bottom
                          const Spacer(),

                          // Buttons section at bottom
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /* --- Send Reset Link ---- */
                              CustomButtonFactory.primary(
                                text: 'Send Reset Link',
                                onPressed: (isLoading || isPasswordResetSent)
                                    ? null
                                    : _handleResetPassword,
                                levelType: LevelType.redLevel,
                                isLoading: isLoading,
                              ),
                              SizedBox(height: SizeConfig.scaleHeight(16)),

                              Center(child: const Text('Remembered your password? ')),
                              SizedBox(height: SizeConfig.scaleHeight(8)),

                              CustomButtonFactory.text(
                                text: 'Log in',
                                onPressed: () => context.pop(),
                                levelType: LevelType.redLevel,
                                width: SizeConfig.scaleWidth(26),
                              ),

                              SizedBox(height: SizeConfig.scaleHeight(20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}