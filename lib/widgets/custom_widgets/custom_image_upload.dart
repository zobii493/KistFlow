import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomImageUpload extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final String? errorText;

  const CustomImageUpload({
    super.key,
    required this.imageFile,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: [10, 5],
              strokeWidth: 2,
              radius: const Radius.circular(16),
              color: AppColors.primaryTealOf(context),
              padding: const EdgeInsets.all(8),
            ),
            child: Container(
              height: 160,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: imageFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_rounded,
                    size: 40,
                    color: AppColors.darkGreyOf(context).withAlpha(120),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Click to upload item image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGreyOf(context),
                    ),
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xffb72525), fontSize: 12),
            ),
          ),
      ],
    );
  }
}
