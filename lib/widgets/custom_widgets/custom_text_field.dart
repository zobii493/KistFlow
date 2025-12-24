import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../../core/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final Widget? suffixIcon;
  final Color? fillColor;
  final int maxLines;
  final bool requiredField;
  final String? mask;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.readOnly = false,
    this.suffixIcon,
    this.fillColor,
    this.maxLines = 1,
    this.requiredField = false,
    this.mask,
  }) : super(key: key);

  String? _validate(String? value) {
    if (requiredField && (value == null || value.isEmpty)) {
      return 'This field is required';
    }

    if (mask != null && value != null && value.isNotEmpty) {
      // CNIC validation: xxxxx-xxxxxxx-x
      if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value)) {
        return 'Invalid format: xxxxx-xxxxxxx-x';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: mask != null
              ? [MaskedInputFormatter(mask!)]
              : inputFormatters,
          cursorColor: AppColors.primaryTealOf(context),
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.darkGreyOf(context), fontSize: 14),
            filled: true,
            fillColor: fillColor ?? AppColors.offWhiteOf(context),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryTealOf(context),
                width: 1.5,
              ),
            ),
            suffixIcon: suffixIcon,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validate,
        ),
      ],
    );
  }
}
