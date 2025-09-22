import 'dart:io';
import 'package:bitesize_golf/Models/club%20model/golf_club_model.dart';
import 'package:bitesize_golf/core/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../core/utils/user_utils.dart';
import '../../components/custom_button.dart';
import '../../components/custom_image_picker.dart';
import '../../components/custom_scaffold.dart';
import '../../components/text_field_component.dart';
import '../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../repositories/auth_repo.dart';

class UpdateProfileCoachPage extends StatefulWidget {
  const UpdateProfileCoachPage({super.key});

  @override
  State<UpdateProfileCoachPage> createState() => _UpdateProfileCoachPageState();
}

class _UpdateProfileCoachPageState extends State<UpdateProfileCoachPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();

  File? _profileImage;
  String? _selectedGolfClubId;
  String? _selectedGolfClubName;
  List<ClubModel> _clubs = [];
  final AuthRepository clubRepository = AuthRepository();

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    experienceCtrl.dispose();
    golfClubCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated ||
        authState is AuthProfileCompletionRequired) {
      final user = (authState as dynamic).user;

      // ✅ Safely check for firstName / lastName in your UserModel
      if (user.firstName != null && user.firstName!.isNotEmpty) {
        firstNameCtrl.text = user.firstName!;
      }
      if (user.lastName != null && user.lastName!.isNotEmpty) {
        lastNameCtrl.text = user.lastName!;
      }
    } else {
      context.go(RouteNames.welcome);
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = await UserUtil().getCurrentUser(); // 🔥 from util
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final fullName = '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}';

    context.read<AuthBloc>().add(
      AuthCompleteCoachProfileRequested(
        coachId: user.uid,
        userId: user.uid,
        name: fullName,
        experience: int.tryParse(experienceCtrl.text.trim()),
        selectedClubId: _selectedGolfClubId,
        selectedClubName: _selectedGolfClubName,
        profilePic: _profileImage?.path,
      ),
    );
  }

  void _handleSkip() {
    context.go(RouteNames.pendingVerification);
  }

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
        builder: (_) => SizedBox(
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          NavigationService.push('${RouteNames.letsStart}?isPupil=false');
        } else if (state is AuthCoachPendingVerification) {
          context.go(RouteNames.pendingVerification);
        } else if (state is AuthError) {
          SnackBarUtils.showErrorSnackBar(
            context,
            message: state.message,
            levelNumber: 1,
          );
        }
      },

      builder: (context, state) {
        final isLoading = state is AuthLoading;

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

                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  label: 'First Name',
                  placeholder: 'Emma',
                  levelType: LevelType.redLevel,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your first name'
                      : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  label: 'Last Name',
                  placeholder: 'Wilson',
                  levelType: LevelType.redLevel,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your last name'
                      : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

                CustomTextFieldFactory.number(
                  controller: experienceCtrl,
                  label: 'Experience',
                  placeholder: 'Enter your Experience',
                  levelType: LevelType.redLevel,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your years of experience'
                      : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),

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

                SizedBox(
                  width: 900,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: CustomImagePicker(
                          image: _profileImage,
                          size: 200,
                          onImage: (f) => setState(() => _profileImage = f),
                          levelType: LevelType.redLevel,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(32)),
                CustomButtonFactory.primary(
                  text: 'Save and Continue',
                  onPressed: isLoading ? null : _handleSaveProfile,
                  levelType: LevelType.redLevel,
                  isLoading: isLoading,
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),
                // Center(
                //   child: CustomButtonFactory.text(
                //     text: 'Skip for now',
                //     onPressed: isLoading ? null : _handleSkip,
                //     levelType: LevelType.redLevel,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
