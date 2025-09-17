import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/size_config.dart';
import '../../../../core/themes/theme_colors.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final handicapCtrl = TextEditingController();
  final coachNameCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();
  DateTime? _selectedDateOfBirth;
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 8)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _selectedDateOfBirth = date;
        dobCtrl.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  void _selectGolfClub() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(

      ),
    );
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    dobCtrl.dispose();
    handicapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.form(
      title: 'Edit Profile',
      showBackButton: true,
      scrollable: true,
      levelType: LevelType.redLevel,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: SizeConfig.scaleWidth(45),
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const NetworkImage("https://via.placeholder.com/150")
                  as ImageProvider,
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
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(24)),

          CustomTextFieldFactory.name(
            controller: firstNameCtrl,
            levelType: LevelType.redLevel,
            label: 'First Name',
            placeholder: 'Enter first name',
          ),
          SizedBox(height: SizeConfig.scaleHeight(20)),

          CustomTextFieldFactory.name(
            controller: lastNameCtrl,
            levelType: LevelType.redLevel,
            label: 'Last Name',
            placeholder: 'Enter last name',
          ),
          SizedBox(height: SizeConfig.scaleHeight(20)),

          CustomTextFieldFactory.date(
            controller: dobCtrl,
            label: 'Date of Birth',
            placeholder: 'DD/MM/YYYY',
            levelType: LevelType.redLevel,
            onTap: _selectDate,
            validator: (v) =>
            (v ?? '').trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: SizeConfig.scaleHeight(20)),

          CustomTextFieldFactory.number(
            controller: handicapCtrl,
            levelType: LevelType.redLevel,
            label: 'Handicap',
            placeholder: 'Enter handicap',
          ),
          SizedBox(height: SizeConfig.scaleHeight(20)),

          CustomTextFieldFactory.name(
            controller: coachNameCtrl,
            levelType: LevelType.redLevel,
            label: 'Coach Name',
            placeholder: 'Enter coach name',
          ),
          SizedBox(height: SizeConfig.scaleHeight(20)),

          CustomTextFieldFactory.dropdown(
            controller: golfClubCtrl,
            levelType: LevelType.redLevel,
            label: 'Golf Club',
            placeholder: 'Select Golf Club',
            onTap: _selectGolfClub,
          ),
          SizedBox(height: SizeConfig.scaleHeight(32)),

          CustomButtonFactory.primary(
            text: "Save Changes",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile changes saved (local only)")),
              );
            },
            levelType: LevelType.redLevel,
            size: ButtonSize.medium,
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),

          CustomButtonFactory.text(
            text: "Cancel",
            onPressed: () => Navigator.pop(context),
            levelType: LevelType.redLevel,
            size: ButtonSize.medium,
          ),
          SizedBox(height: SizeConfig.scaleHeight(24)),
        ],
      ),
    );
  }
}
