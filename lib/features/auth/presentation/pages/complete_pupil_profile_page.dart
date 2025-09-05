// features/auth/presentation/pages/complete_profile_pupil_page.dart
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

class CompleteProfilePupilPage extends StatefulWidget {
  const CompleteProfilePupilPage({super.key});

  @override
  State<CompleteProfilePupilPage> createState() =>
      _CompleteProfilePupilPageState();
}

class _CompleteProfilePupilPageState extends State<CompleteProfilePupilPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final handicapCtrl = TextEditingController();
  final coachNameCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();

  File? _profileImage;
  DateTime? _selectedDateOfBirth;
  String? _selectedGolfClub;
  String? _selectedCoach;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state;
    if (user is AuthAuthenticated) {
      firstNameCtrl.text = user.user.displayName?.split(" ").first ?? '';
      lastNameCtrl.text = user.user.displayName?.split(" ").last ?? '';
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    dateOfBirthCtrl.dispose();
    handicapCtrl.dispose();
    coachNameCtrl.dispose();
    golfClubCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 80)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
        dateOfBirthCtrl.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
        'handicap': handicapCtrl.text.trim(),
        'coachName': _selectedCoach,
        'golfClubOrFacility': _selectedGolfClub,
        'profileCompleted': true,
        'skillLevel': 'beginner',
        'learningGoals': [],
      };
      context.read<AuthBloc>().add(AuthUpdateProfile(data));
    }
  }

  void _skip() => context.go(RouteNames.pupilHome);

  /* ---------- Dropdown helpers ---------- */
  void _showClubSheet() {
    final clubs = [
      'Local Golf Club',
      'Pebble Beach Golf Links',
      'Augusta National Golf Club',
      'St Andrews Links',
      'Pinehurst Resort',
      'TPC Sawgrass',
      'Bandon Dunes Golf Resort',
      'Whistling Straits',
      'Torrey Pines Golf Course',
      'Spyglass Hill Golf Course',
    ];
    _showPicker(clubs, (v) {
      _selectedGolfClub = v;
      golfClubCtrl.text = v;
    });
  }

  void _showCoachSheet() {
    final coaches = [
      'Coach Mike Johnson',
      'Coach Sarah Williams',
      'Coach David Brown',
      'Coach Emma Davis',
      'Coach Robert Smith',
    ];
    _showPicker(['No Coach (Self-learning)', ...coaches], (v) {
      _selectedCoach = v == 'No Coach (Self-learning)' ? null : v;
      coachNameCtrl.text = _selectedCoach ?? '';
    });
  }

  void _showPicker(List<String> items, ValueChanged<String> onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
              child: Text(
                'Select',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.scaleWidth(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: items
                    .map(
                      (e) => ListTile(
                        title: Text(e),
                        onTap: () {
                          onSelect(e);
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CustomAppBar(
        title: 'Complete Your Profile',
        levelType: LevelType.redLevel,
        centerTitle: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthProfileUpdated) {
            context.go(RouteNames.pupilHome);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (_, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: SizeConfig.scaleHeight(20)),

                  /* ---- Header ---- */
                  Text(
                    'Tell us a bit more about yourself to personalize your experience.',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.scaleWidth(16),
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(32)),

                  /* ---- Photo ---- */
                  Center(
                    child: CustomImagePicker(
                      image: _profileImage,
                      onImage: (f) => setState(() => _profileImage = f),
                      levelType: LevelType.redLevel,
                    ),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(32)),

                  /* ---- Names ---- */
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldFactory.name(
                          controller: firstNameCtrl,
                          label: 'First Name *',
                          placeholder: 'Alex',
                          levelType: LevelType.redLevel,
                          validator: (v) =>
                              (v ?? '').trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                      SizedBox(width: SizeConfig.scaleWidth(12)),
                      Expanded(
                        child: CustomTextFieldFactory.name(
                          controller: lastNameCtrl,
                          label: 'Last Name *',
                          placeholder: 'Johnson',
                          levelType: LevelType.redLevel,
                          validator: (v) =>
                              (v ?? '').trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(20)),

                  /* ---- Date ---- */
                  CustomTextFieldFactory.date(
                    controller: dateOfBirthCtrl,
                    label: 'Date of Birth *',
                    placeholder: 'MM/DD/YYYY',
                    levelType: LevelType.redLevel,
                    onTap: () => _selectDate(context),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(20)),

                  /* ---- Handicap ---- */
                  CustomTextFieldFactory.number(
                    controller: handicapCtrl,
                    label: 'Current Handicap *',
                    placeholder: 'e.g. 14',
                    levelType: LevelType.redLevel,
                    validator: (v) {
                      final val = int.tryParse((v ?? '').trim());
                      if (val == null || val < 0 || val > 36) {
                        return '0-36 only';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(20)),

                  /* ---- Golf Club ---- */
                  CustomTextFieldFactory.dropdown(
                    controller: golfClubCtrl,
                    label: 'Primary Golf Club *',
                    placeholder: 'Select Golf Club or Facility',
                    levelType: LevelType.redLevel,
                    onTap: _showClubSheet,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(20)),

                  /* ---- Coach ---- */
                  CustomTextFieldFactory.dropdown(
                    controller: coachNameCtrl,
                    label: 'Coach (Optional)',
                    placeholder: 'Select Coach',
                    levelType: LevelType.redLevel,
                    onTap: _showCoachSheet,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(40)),

                  /* ---- Buttons ---- */
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonFactory.outline(
                          text: 'Skip for now',
                          onPressed: _skip,
                          levelType: LevelType.redLevel,
                        ),
                      ),
                      SizedBox(width: SizeConfig.scaleWidth(12)),
                      Expanded(
                        child: CustomButtonFactory.primary(
                          text: 'Save and Continue',
                          onPressed: isLoading ? null : _save,
                          levelType: LevelType.redLevel,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
