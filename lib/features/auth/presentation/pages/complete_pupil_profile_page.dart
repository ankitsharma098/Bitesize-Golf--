// // features/auth/presentation/pages/complete_profile_pupil_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/custom_app_bar.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

// class CompleteProfilePupilPage extends StatefulWidget {
//   const CompleteProfilePupilPage({super.key});
//
//   @override
//   State<CompleteProfilePupilPage> createState() =>
//       _CompleteProfilePupilPageState();
// }
//
// class _CompleteProfilePupilPageState extends State<CompleteProfilePupilPage> {
//   final _formKey = GlobalKey<FormState>();
//   final firstNameCtrl = TextEditingController();
//   final lastNameCtrl = TextEditingController();
//   final dateOfBirthCtrl = TextEditingController();
//   final handicapCtrl = TextEditingController();
//   final coachNameCtrl = TextEditingController();
//   final golfClubCtrl = TextEditingController();
//
//   File? _profileImage;
//   DateTime? _selectedDateOfBirth;
//   String? _selectedGolfClub;
//   String? _selectedCoach;
//
//   @override
//   void initState() {
//     super.initState();
//     final user = context.read<AuthBloc>().state;
//     if (user is AuthAuthenticated) {
//       firstNameCtrl.text = user.user.displayName?.split(" ").first ?? '';
//       lastNameCtrl.text = user.user.displayName?.split(" ").last ?? '';
//     }
//   }
//
//   @override
//   void dispose() {
//     firstNameCtrl.dispose();
//     lastNameCtrl.dispose();
//     dateOfBirthCtrl.dispose();
//     handicapCtrl.dispose();
//     coachNameCtrl.dispose();
//     golfClubCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
//       firstDate: DateTime.now().subtract(const Duration(days: 365 * 80)),
//       lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDateOfBirth = picked;
//         dateOfBirthCtrl.text = DateFormat('MM/dd/yyyy').format(picked);
//       });
//     }
//   }
//
//   void _save() {
//     if (!_formKey.currentState!.validate()) return;
//     final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
//
//     context.read<AuthBloc>().add(
//       AuthCompletePupilProfileRequested(
//         pupilId: user.uid,
//         parentId: user.uid, // parent == self for now
//         name: '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}',
//         dateOfBirth: _selectedDateOfBirth,
//         handicap: handicapCtrl.text.trim().isEmpty
//             ? null
//             : handicapCtrl.text.trim(),
//         selectedCoachName: coachNameCtrl.text.trim().isEmpty
//             ? null
//             : coachNameCtrl.text.trim(),
//         selectedClubId: golfClubCtrl.text.trim().isEmpty
//             ? null
//             : golfClubCtrl.text.trim(),
//         avatar: null, // you can wire image upload later
//       ),
//     );
//   }
//
//   void _skip() => context.go(RouteNames.pupilHome);
//
//   /* ---------- Dropdown helpers ---------- */
//   void _showClubSheet() {
//     final clubs = [
//       'Local Golf Club',
//       'Pebble Beach Golf Links',
//       'Augusta National Golf Club',
//       'St Andrews Links',
//       'Pinehurst Resort',
//       'TPC Sawgrass',
//       'Bandon Dunes Golf Resort',
//       'Whistling Straits',
//       'Torrey Pines Golf Course',
//       'Spyglass Hill Golf Course',
//     ];
//     _showPicker(clubs, (v) {
//       _selectedGolfClub = v;
//       golfClubCtrl.text = v;
//     });
//   }
//
//   void _showCoachSheet() {
//     final coaches = [
//       'Coach Mike Johnson',
//       'Coach Sarah Williams',
//       'Coach David Brown',
//       'Coach Emma Davis',
//       'Coach Robert Smith',
//     ];
//     _showPicker(['No Coach (Self-learning)', ...coaches], (v) {
//       _selectedCoach = v == 'No Coach (Self-learning)' ? null : v;
//       coachNameCtrl.text = _selectedCoach ?? '';
//     });
//   }
//
//   void _showPicker(List<String> items, ValueChanged<String> onSelect) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 300,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
//               child: Text(
//                 'Select',
//                 style: GoogleFonts.inter(
//                   fontSize: SizeConfig.scaleWidth(18),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: items
//                     .map(
//                       (e) => ListTile(
//                         title: Text(e),
//                         onTap: () {
//                           onSelect(e);
//                           Navigator.pop(context);
//                         },
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBgColor,
//       appBar: CustomAppBar(
//         title: 'Complete Your Profile',
//         levelType: LevelType.redLevel,
//         centerTitle: false,
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (_, state) {
//           if (state is AuthCompletePupilProfileRequested) {
//             context.go(RouteNames.pupilHome);
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (_, state) {
//           final isLoading = state is AuthLoading;
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                   /* ---- Header ---- */
//                   Text(
//                     'Tell us a bit more about yourself to personalize your experience.',
//                     style: GoogleFonts.inter(
//                       fontSize: SizeConfig.scaleWidth(16),
//                       color: AppColors.grey600,
//                     ),
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(32)),
//
//                   /* ---- Photo ---- */
//                   Center(
//                     child: CustomImagePicker(
//                       image: _profileImage,
//                       onImage: (f) => setState(() => _profileImage = f),
//                       levelType: LevelType.redLevel,
//                     ),
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(32)),
//
//                   /* ---- Names ---- */
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextFieldFactory.name(
//                           controller: firstNameCtrl,
//                           label: 'First Name *',
//                           placeholder: 'Alex',
//                           levelType: LevelType.redLevel,
//                           validator: (v) =>
//                               (v ?? '').trim().isEmpty ? 'Required' : null,
//                         ),
//                       ),
//                       SizedBox(width: SizeConfig.scaleWidth(12)),
//                       Expanded(
//                         child: CustomTextFieldFactory.name(
//                           controller: lastNameCtrl,
//                           label: 'Last Name *',
//                           placeholder: 'Johnson',
//                           levelType: LevelType.redLevel,
//                           validator: (v) =>
//                               (v ?? '').trim().isEmpty ? 'Required' : null,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                   /* ---- Date ---- */
//                   CustomTextFieldFactory.date(
//                     controller: dateOfBirthCtrl,
//                     label: 'Date of Birth *',
//                     placeholder: 'MM/DD/YYYY',
//                     levelType: LevelType.redLevel,
//                     onTap: () => _selectDate(context),
//                     validator: (v) =>
//                         (v ?? '').trim().isEmpty ? 'Required' : null,
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                   /* ---- Handicap ---- */
//                   CustomTextFieldFactory.number(
//                     controller: handicapCtrl,
//                     label: 'Current Handicap *',
//                     placeholder: 'e.g. 14',
//                     levelType: LevelType.redLevel,
//                     validator: (v) {
//                       final val = int.tryParse((v ?? '').trim());
//                       if (val == null || val < 0 || val > 36) {
//                         return '0-36 only';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                   /* ---- Golf Club ---- */
//                   CustomTextFieldFactory.dropdown(
//                     controller: golfClubCtrl,
//                     label: 'Primary Golf Club *',
//                     placeholder: 'Select Golf Club or Facility',
//                     levelType: LevelType.redLevel,
//                     onTap: _showClubSheet,
//                     validator: (v) =>
//                         (v ?? '').trim().isEmpty ? 'Required' : null,
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(20)),
//
//                   /* ---- Coach ---- */
//                   CustomTextFieldFactory.dropdown(
//                     controller: coachNameCtrl,
//                     label: 'Coach (Optional)',
//                     placeholder: 'Select Coach',
//                     levelType: LevelType.redLevel,
//                     onTap: _showCoachSheet,
//                   ),
//                   SizedBox(height: SizeConfig.scaleHeight(40)),
//
//                   /* ---- Buttons ---- */
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButtonFactory.outline(
//                           text: 'Skip for now',
//                           onPressed: _skip,
//                           levelType: LevelType.redLevel,
//                         ),
//                       ),
//                       SizedBox(width: SizeConfig.scaleWidth(12)),
//                       Expanded(
//                         child: CustomButtonFactory.primary(
//                           text: 'Save and Continue',
//                           onPressed: isLoading ? null : _save,
//                           levelType: LevelType.redLevel,
//                           isLoading: isLoading,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class CompletePupilProfilePage extends StatefulWidget {
  const CompletePupilProfilePage({super.key});

  @override
  State<CompletePupilProfilePage> createState() =>
      _CompletePupilProfilePageState();
}

class _CompletePupilProfilePageState extends State<CompletePupilProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final handicapCtrl = TextEditingController();
  final coachNameCtrl = TextEditingController();

  DateTime? _selectedDateOfBirth;
  String? _selectedClubId;
  String? _selectedAvatar;

  @override
  void dispose() {
    nameCtrl.dispose();
    handicapCtrl.dispose();
    coachNameCtrl.dispose();
    super.dispose();
  }

  void _handleComplete() {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = context.read<AuthBloc>().state;
    if (currentUser is! AuthProfileCompletionRequired) return;

    final pupilId =
        '${currentUser.user.uid}_${DateTime.now().millisecondsSinceEpoch}';

    context.read<AuthBloc>().add(
      AuthCompletePupilProfileRequested(
        pupilId: pupilId,
        parentId: currentUser.user.uid,
        name: nameCtrl.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        handicap: handicapCtrl.text.trim().isNotEmpty
            ? handicapCtrl.text.trim()
            : null,
        selectedCoachName: coachNameCtrl.text.trim().isNotEmpty
            ? coachNameCtrl.text.trim()
            : null,
        selectedClubId: _selectedClubId,
        avatar: _selectedAvatar,
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 8)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _selectedDateOfBirth = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Your Child\'s Profile',
        centerTitle: false,
        showBackButton: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile completed successfully!')),
            );
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
              padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome message
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.child_care,
                              size: 48,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Let\'s set up your child\'s golf learning profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This information helps us personalize their learning experience',
                              style: TextStyle(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(24)),

                    // Child's name (required)
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Child\'s Name *',
                        hintText: 'Enter your child\'s name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Name is required' : null,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Date of birth (optional but recommended)
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth (Optional)',
                          hintText: 'Select date of birth',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDateOfBirth != null
                              ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                              : 'Tap to select date',
                          style: TextStyle(
                            color: _selectedDateOfBirth != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Handicap (optional)
                    TextFormField(
                      controller: handicapCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Golf Handicap (Optional)',
                        hintText: 'e.g., 15 or Beginner',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Coach name (optional)
                    TextFormField(
                      controller: coachNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Preferred Coach Name (Optional)',
                        hintText: 'Enter coach name if you have one in mind',
                        border: OutlineInputBorder(),
                        helperText:
                            'We\'ll send a request to this coach for approval',
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(24)),

                    // Info card
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(height: 8),
                            const Text(
                              'Getting Started',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'After completing this profile, you can:\n'
                              '• Browse free lessons and activities\n'
                              '• Track your child\'s progress\n'
                              '• Connect with verified coaches\n'
                              '• Unlock premium content with a subscription',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(32)),

                    // Complete button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleComplete,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Complete Profile',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Skip option
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Create minimal profile
                              final currentUser = context
                                  .read<AuthBloc>()
                                  .state;
                              if (currentUser
                                  is AuthProfileCompletionRequired) {
                                final pupilId =
                                    '${currentUser.user.uid}_${DateTime.now().millisecondsSinceEpoch}';
                                context.read<AuthBloc>().add(
                                  AuthCompletePupilProfileRequested(
                                    pupilId: pupilId,
                                    parentId: currentUser.user.uid,
                                    name: 'My Child', // Default name
                                  ),
                                );
                              }
                            },
                      child: const Text('Skip for Now'),
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
