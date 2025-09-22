import 'dart:io';
import 'package:bitesize_golf/core/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Models/coaches model/coach_model.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/size_config.dart';
import '../edit bloc/edit_coach_bloc.dart';

class EditCoachPage extends StatefulWidget {
  const EditCoachPage({super.key});

  @override
  State<EditCoachPage> createState() => _EditCoachPageState();
}

class _EditCoachPageState extends State<EditCoachPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final clubCtrl = TextEditingController();

  File? _profileImage;
  String? _selectedClubId;
  String? _selectedClubName;
  String? _currentProfilePicUrl;

  @override
  void initState() {
    super.initState();
    context.read<EditCoachBloc>().add(LoadCoachProfile());
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    experienceCtrl.dispose();
    clubCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final updatedCoach = {
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "experience": experienceCtrl.text.trim(),
      "clubId": _selectedClubId,
      "clubName": _selectedClubName ?? clubCtrl.text.trim(),
      "profilePic": _profileImage?.path ?? _currentProfilePicUrl,
    };

    context.read<EditCoachBloc>().add(SaveCoachProfile(updatedCoach));
  }

  void _populateFields(CoachModel coach) {
    // Split name into first and last name
    final nameParts = coach.name.split(' ');
    firstNameCtrl.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameCtrl.text = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    experienceCtrl.text = coach.experience?.toString() ?? '';
    clubCtrl.text = coach.selectedClubName ?? '';

    _selectedClubId = coach.assignedClubId;
    _selectedClubName = coach.assignedClubName;
    _currentProfilePicUrl = coach.profilePic;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCoachBloc, EditCoachState>(
      listener: (context, state) {
        if (state is EditCoachLoaded) {
          _populateFields(state.coach);
        }
        if (state is EditCoachSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
          Navigator.pop(context);
        }
        if (state is EditCoachError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is EditCoachLoading;

        return AppScaffold.form(
          title: "Edit Profile",
          showBackButton: true,
          scrollable: true,
          levelType: LevelType.redLevel,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Image Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: SizeConfig.scaleWidth(45),
                        backgroundImage: _getProfileImage(),
                        backgroundColor: AppColors.grey200,
                        child: _getProfileImage() == null
                            ? Icon(
                                Icons.person,
                                size: SizeConfig.scaleWidth(45),
                                color: AppColors.grey600,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.redDark,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),

                // First Name Field
                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  label: "First Name",
                  placeholder: "Enter First Name",
                  levelType: LevelType.redLevel,
                  validator: (v) => (v ?? "").trim().isEmpty
                      ? "First name is required"
                      : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // Last Name Field
                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  label: "Last Name",
                  placeholder: "Enter Last Name",
                  levelType: LevelType.redLevel,
                  validator: (v) =>
                      (v ?? "").trim().isEmpty ? "Last name is required" : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // Experience Field
                CustomTextFieldFactory.number(
                  controller: experienceCtrl,
                  label: "Experience (Years)",
                  placeholder: "e.g. 5",
                  levelType: LevelType.redLevel,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final experience = int.tryParse(v.trim());
                    if (experience == null) {
                      return "Please enter a valid number";
                    }
                    if (experience < 0) {
                      return "Experience cannot be negative";
                    }
                    if (experience > 50) {
                      return "Experience seems too high";
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                // Golf Club Field (disabled for now)
                CustomTextFieldFactory.dropdown(
                  controller: clubCtrl,
                  label: "Golf Club",
                  placeholder: "Select Golf Club",
                  levelType: LevelType.redLevel,
                  locked: true, // 🔒 now disabled
                  onTap: () {
                    SnackBarUtils.showInfoSnackBar(
                      context,
                      message: 'Club selection coming soon!',
                      levelNumber: 1,
                    );
                  },
                ),

                SizedBox(height: SizeConfig.scaleHeight(40)),

                // Save Button
                CustomButtonFactory.primary(
                  text: "Save Changes",
                  onPressed: isLoading ? null : _handleSave,
                  isLoading: isLoading,
                  levelType: LevelType.redLevel,
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),

                // Cancel Button
                CustomButtonFactory.text(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider<Object>? _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    if (_currentProfilePicUrl != null && _currentProfilePicUrl!.isNotEmpty) {
      return NetworkImage(_currentProfilePicUrl!);
    }
    return null;
  }
}
