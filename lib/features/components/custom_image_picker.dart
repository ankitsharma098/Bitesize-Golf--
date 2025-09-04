// features/components/utils/custom_image_picker.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';

class CustomImagePicker extends StatelessWidget {
  final File? image;
  final ValueChanged<File> onImage;
  final double size;
  final LevelType? levelType;

  const CustomImagePicker({
    Key? key,
    required this.image,
    required this.onImage,
    this.size = 120,
    this.levelType,
  }) : super(key: key);

  Future<void> _pick() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onImage(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final accent = levelType?.color ?? Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: _pick,
      child: Container(
        width: SizeConfig.scaleWidth(size),
        height: SizeConfig.scaleWidth(size),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          shape: BoxShape.circle,
          border: Border.all(color: accent, width: 2),
        ),
        child: image != null
            ? ClipOval(child: Image.file(image!, fit: BoxFit.cover))
            : Icon(Icons.camera_alt, color: AppColors.grey600),
      ),
    );
  }
}
