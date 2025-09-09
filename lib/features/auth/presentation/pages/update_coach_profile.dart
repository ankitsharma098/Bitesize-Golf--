// features/auth/presentation/pages/complete_profile_coach_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/themes/theme_colors.dart';
import '../../../../injection.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../club/domain/entities/golf_club_entity.dart';
import '../../../club/domain/usecases/get_club_useCase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class UpdateProfileCoachPage extends StatefulWidget {
  const UpdateProfileCoachPage({super.key});

  @override
  State<UpdateProfileCoachPage> createState() => _UpdateProfileCoachPageState();
}

class _UpdateProfileCoachPageState extends State<UpdateProfileCoachPage> {
  final GetClubsUseCase getClubsUseCase = getIt<GetClubsUseCase>();
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final certificationsCtrl = TextEditingController();

  File? _profileImage;
  String? _selectedGolfClubId;
  String? _selectedGolfClubName;
  List<String> _certifications = [];

  List<Club> _clubs = [];
  Club? _selectedClub;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      final user = authState.user;
      print(
        "UpdateProfileCoachPage - User: ${user.displayName}, ${user.email}",
      );

      // Pre-fill form with existing user data
      if (user.displayName != null && user.displayName!.contains(' ')) {
        final nameParts = user.displayName!.split(' ');
        firstNameCtrl.text = nameParts.first;
        lastNameCtrl.text = nameParts.sublist(1).join(' ');
      } else if (user.firstName != null && user.lastName != null) {
        firstNameCtrl.text = user.firstName!;
        lastNameCtrl.text = user.lastName!;
      }
    } else if (authState is AuthProfileCompletionRequired) {
      final user = authState.user;
      print(
        "UpdateProfileCoachPage - Profile completion required for: ${user.displayName}",
      );

      // Pre-fill form with existing user data
      if (user.displayName != null && user.displayName!.contains(' ')) {
        final nameParts = user.displayName!.split(' ');
        firstNameCtrl.text = nameParts.first;
        lastNameCtrl.text = nameParts.sublist(1).join(' ');
      } else if (user.firstName != null && user.lastName != null) {
        firstNameCtrl.text = user.firstName!;
        lastNameCtrl.text = user.lastName!;
      }
    } else {
      print("UpdateProfileCoachPage - No authenticated user found");
      context.go(RouteNames.welcome);
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
    if (!_formKey.currentState!.validate()) return;

    // Get user from current state
    final authState = context.read<AuthBloc>().state;
    String userId;

    if (authState is AuthAuthenticated) {
      userId = authState.user.uid;
    } else if (authState is AuthProfileCompletionRequired) {
      userId = authState.user.uid;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User authentication error')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthCompleteCoachProfileRequested(
        coachId: userId,
        userId: userId,
        name: '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}',
        bio: bioCtrl.text.trim().isEmpty ? null : bioCtrl.text.trim(),
        experience: int.tryParse(experienceCtrl.text.trim()),
        selectedClubId: _selectedGolfClubId,
        selectedClubName: _selectedGolfClubName,
      ),
    );
  }

  void _handleSkip() {
    context.go(RouteNames.coachHome);
  }

  void _selectGolfClub() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await getClubsUseCase();

    // Close loading dialog
    if (mounted) Navigator.pop(context);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (clubs) {
        if (!mounted) return;

        setState(() {
          _clubs = clubs;
        });

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Select Golf Club or Facility',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: clubs.length,
                    itemBuilder: (context, index) {
                      final club = clubs[index];
                      return ListTile(
                        title: Text(club.name),
                        subtitle: Text(club.location),
                        onTap: () {
                          setState(() {
                            _selectedClub = club;
                            _selectedGolfClubId = club.id;
                            _selectedGolfClubName = club.name;
                            golfClubCtrl.text = club.name;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53E3E),
        foregroundColor: Colors.white,
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            NavigationService.push(RouteNames.letStart);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header text
                  const Text(
                    'Set up your coach account to start managing pupils modules and sessions.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // First Name
                  const Text(
                    'First Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: firstNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Emma',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE53E3E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  const Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: lastNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Wilson',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE53E3E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Experience
                  const Text(
                    'Years of Experience',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: experienceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g., 5',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE53E3E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your years of experience';
                      }
                      final years = int.tryParse(value);
                      if (years == null || years < 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Golf Club or Facility
                  const Text(
                    'Golf Club or Facility',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectGolfClub,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedGolfClubName ??
                                  'Select Golf Club or Facility',
                              style: TextStyle(
                                color: _selectedGolfClubName != null
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bio (Optional)
                  const Text(
                    'Bio (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: bioCtrl,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Tell us about your coaching experience...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE53E3E)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Certifications
                  const Text(
                    'Certifications (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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
                  const SizedBox(height: 16),

                  // Profile Photo
                  const Text(
                    'Profile Photo (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 32,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload photo',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save and Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSaveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save and Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skip for now button
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : _handleSkip,
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Color(0xFFE53E3E),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
