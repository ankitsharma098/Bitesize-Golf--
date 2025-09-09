import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';

class CustomImagePicker extends StatefulWidget {
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

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      widget.onImage(File(picked.path));
    }
  }

  void _removeImage() {
    setState(() {
      widget.onImage(File('')); // Clear the image
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.levelType?.color ?? Theme.of(context).primaryColor;
    final hasImage = widget.image != null && widget.image!.path.isNotEmpty;

    return GestureDetector(
      onTap: hasImage ? null : _pickImage, // Disable tap if image is present
      child: Container(
        width: SizeConfig.scaleWidth(widget.size),
        height: SizeConfig.scaleWidth(widget.size),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
            if (hasImage)
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53E3E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
