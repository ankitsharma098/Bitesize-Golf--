// features/auth/presentation/pages/complete_profile_pupil_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io';
import '../../../../route/routes_names.dart';
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
  bool _isLoading = false;
  DateTime? _selectedDateOfBirth;
  String? _selectedGolfClub;
  String? _selectedCoach;

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
    dateOfBirthCtrl.dispose();
    handicapCtrl.dispose();
    coachNameCtrl.dispose();
    golfClubCtrl.dispose();
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

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
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

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
        'handicap': handicapCtrl.text.trim(),
        'coachName': _selectedCoach,
        'golfClubOrFacility': _selectedGolfClub,
        'profileCompleted': true,
        'skillLevel': 'beginner', // Default
        'learningGoals': [],
      };

      context.read<AuthBloc>().add(AuthUpdateProfile(profileData));
    }
  }

  void _handleSkip() {
    context.go(RouteNames.pupilHome);
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

  void _selectCoach() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Coach (Optional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('No Coach (Self-learning)'),
                    onTap: () {
                      setState(() {
                        _selectedCoach = null;
                        coachNameCtrl.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ..._getCoaches().map(
                    (coach) => ListTile(
                      title: Text(coach),
                      subtitle: const Text('Available for mentorship'),
                      onTap: () {
                        setState(() {
                          _selectedCoach = coach;
                          coachNameCtrl.text = coach;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getGolfClubs() => [
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

  List<String> _getCoaches() => [
    'Coach Mike Johnson',
    'Coach Sarah Williams',
    'Coach David Brown',
    'Coach Emma Davis',
    'Coach Robert Smith',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        elevation: 0,
        actions: [
          TextButton(onPressed: _handleSkip, child: const Text('Skip')),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileUpdated) {
            context.go(RouteNames.pupilHome);
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
                    'Tell Us About Yourself',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Help us personalize your learning experience',
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

                  // Date of Birth
                  TextFormField(
                    controller: dateOfBirthCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth *',
                      hintText: 'MM/DD/YYYY',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectDateOfBirth,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Handicap
                  TextFormField(
                    controller: handicapCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Current Handicap *',
                      hintText: 'e.g., 14',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your handicap';
                      }
                      final handicap = int.tryParse(value);
                      if (handicap == null || handicap < 0 || handicap > 36) {
                        return 'Please enter a valid handicap (0-36)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Golf Club
                  TextFormField(
                    controller: golfClubCtrl,
                    decoration: InputDecoration(
                      labelText: 'Primary Golf Club *',
                      hintText: 'Select your golf club',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectGolfClub,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a golf club';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Coach Selection
                  TextFormField(
                    controller: coachNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Coach (Optional)',
                      hintText: 'Select a coach for guidance',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectCoach,
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
