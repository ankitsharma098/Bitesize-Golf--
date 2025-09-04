// features/auth/presentation/pages/complete_profile_coach_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/routes_names.dart';
import '../bloc/auth_bloc.dart';

class CompleteProfileCoachPage extends StatefulWidget {
  const CompleteProfileCoachPage({super.key});

  @override
  State<CompleteProfileCoachPage> createState() =>
      _CompleteProfileCoachPageState();
}

class _CompleteProfileCoachPageState extends State<CompleteProfileCoachPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final certificationsCtrl = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;
  String? _selectedGolfClub;
  List<String> _certifications = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data
    final currentUser = context.read<AuthBloc>().state;
    if (currentUser is AuthAuthenticated) {
      firstNameCtrl.text = currentUser.user.firstName ?? '';
      lastNameCtrl.text = currentUser.user.lastName ?? '';
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    experienceCtrl.dispose();
    golfClubCtrl.dispose();
    bioCtrl.dispose();
    certificationsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'experience': int.tryParse(experienceCtrl.text.trim()) ?? 0,
        'golfClubOrFacility': _selectedGolfClub,
        'profileCompleted': true,
        'bio': bioCtrl.text.trim(),
        'certifications': _certifications,
        'isAvailable': true,
        'maxPupils': 20,
      };

      context.read<AuthBloc>().add(AuthUpdateProfile(profileData));
    }
  }

  void _handleSkip() {
    context.go(RouteNames.coachHome);
  }

  void _selectGolfClub() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Golf Club or Facility',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ..._getGolfClubs().map(
              (club) => ListTile(
                title: Text(club),
                onTap: () {
                  setState(() {
                    _selectedGolfClub = club;
                    golfClubCtrl.text = club;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCertification() {
    if (certificationsCtrl.text.trim().isNotEmpty) {
      setState(() {
        _certifications.add(certificationsCtrl.text.trim());
        certificationsCtrl.clear();
      });
    }
  }

  List<String> _getGolfClubs() => [
    'Pebble Beach Golf Links',
    'Augusta National Golf Club',
    'St Andrews Links',
    'Pinehurst Resort',
    'TPC Sawgrass',
    'Bandon Dunes Golf Resort',
    'Whistling Straits',
    'Torrey Pines Golf Course',
    'Spyglass Hill Golf Course',
    'Custom Club',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,

      appBar: AppBar(
        title: const Text('Complete Coach Profile'),
        elevation: 0,
        actions: [
          TextButton(onPressed: _handleSkip, child: const Text('Skip')),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileUpdated) {
            context.go(RouteNames.coachHome);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Complete Your Coach Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set up your coach account to start managing pupils and sessions.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Profile Photo
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: _profileImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Personal Info
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'First Name *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Last Name *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Experience
                  TextFormField(
                    controller: experienceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Years of Experience *',
                      hintText: 'e.g., 5',
                      suffixText: 'years',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your experience';
                      }
                      final years = int.tryParse(value);
                      if (years == null || years < 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Golf Club
                  TextFormField(
                    controller: golfClubCtrl,
                    decoration: InputDecoration(
                      labelText: 'Golf Club or Facility *',
                      hintText: 'Select your primary club',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectGolfClub,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a golf club or facility';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  TextFormField(
                    controller: bioCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bio (Optional)',
                      hintText: 'Tell us about your coaching experience...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 16),

                  // Certifications
                  const Text(
                    'Certifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: certificationsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Add Certification',
                            hintText: 'e.g., PGA Certified',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: _addCertification,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Display certifications
                  if (_certifications.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: _certifications
                          .map(
                            (cert) => Chip(
                              label: Text(cert),
                              onDeleted: () {
                                setState(() {
                                  _certifications.remove(cert);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : _handleSkip,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Skip for now'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSaveProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save and Continue'),
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
