import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/themes/theme_colors.dart';
import '../../../../injection.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../club/data/entities/golf_club_entity.dart';
import '../../../club/data/repositories/club_repository.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../../../components/custom_button.dart';
import '../../../components/text_field_component.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class UpdateProfileCoachPage extends StatefulWidget {
  const UpdateProfileCoachPage({super.key});

  @override
  State<UpdateProfileCoachPage> createState() => _UpdateProfileCoachPageState();
}

class _UpdateProfileCoachPageState extends State<UpdateProfileCoachPage> {
  final ClubRepository clubRepository = getIt<ClubRepository>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated ||
        authState is AuthProfileCompletionRequired) {
      final user = (authState as dynamic).user;
      if (user.displayName != null && user.displayName!.contains(' ')) {
        final nameParts = user.displayName!.split(' ');
        firstNameCtrl.text = nameParts.first;
        lastNameCtrl.text = nameParts.sublist(1).join(' ');
      } else if (user.firstName != null && user.lastName != null) {
        firstNameCtrl.text = user.firstName!;
        lastNameCtrl.text = user.lastName!;
      }
    } else {
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
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  void _handleSaveProfile() {
    if (!_formKey.currentState!.validate()) return;
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

  void _handleSkip() => context.go(RouteNames.coachHome);

  void _selectGolfClub() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final clubs = await clubRepository.getAllClubs();
      if (mounted) Navigator.pop(context);
      setState(() => _clubs = clubs);
      if (!mounted) return;
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
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load clubs: $e')));
      }
    }
  }

  void _addCertification() {
    final text = certificationsCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _certifications.add(text);
        certificationsCtrl.clear();
      });
    }
  }

  void _removeCertification(int index) {
    setState(() => _certifications.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          NavigationService.push('${RouteNames.letsStart}?isPupil=false');
          //NavigationService.push(RouteNames.splash);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        // MUCH CLEANER - Using AppScaffold.form() with scrollable
        return AppScaffold.form(
          title: 'Complete Your Profile',
          showBackButton: true,
          levelType: LevelType.redLevel,
          scrollable: true,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set up your coach account to start managing pupils modules and sessions.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),

                // First Name
                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  label: 'First Name',
                  placeholder: 'Emma',
                  levelType: LevelType.redLevel,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

                // Last Name
                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  label: 'Last Name',
                  placeholder: 'Wilson',
                  levelType: LevelType.redLevel,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

                // Experience
                CustomTextFieldFactory.number(
                  controller: experienceCtrl,
                  label: 'Experience',
                  placeholder: 'Enter your Experience',
                  levelType: LevelType.redLevel,
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
                SizedBox(height: SizeConfig.scaleHeight(16)),

                // Golf Club Selection
                CustomTextFieldFactory.dropdown(
                  controller: TextEditingController(
                    text: _selectedGolfClubName ?? '',
                  ),
                  label: 'Golf Club or Facility',
                  placeholder: 'Select Golf Club or Facility',
                  levelType: LevelType.redLevel,
                  onTap: _selectGolfClub,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

                // Profile Photo
                SizedBox(
                  width: 900, // Increased width for a wider cuboid shape
                  height: 120, // Keeping the height as is
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to start (left)
                    children: [
                      Text(
                        'Profile Photo',
                        style: GoogleFonts.inter(
                          fontSize: SizeConfig.scaleWidth(16),
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: SizeConfig.scaleHeight(8)),
                      Expanded(
                        // Use Expanded to fill remaining height
                        child: CustomImagePicker(
                          image: _profileImage,
                          size: 200, // Adjust size to fit within height
                          onImage: (f) => setState(() => _profileImage = f),
                          levelType: LevelType.redLevel,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.scaleHeight(32)),

                // Buttons
                CustomButtonFactory.primary(
                  text: 'Save and Continue',
                  onPressed: isLoading ? null : _handleSaveProfile,
                  levelType: LevelType.redLevel,
                  isLoading: isLoading,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),
                Center(
                  child: CustomButtonFactory.text(
                    text: 'Skip for now',
                    onPressed: isLoading ? null : _handleSkip,
                    levelType: LevelType.redLevel,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
