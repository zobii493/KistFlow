import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../core/app_colors.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(PhoneNumber)? onInputChanged; // NEW: Full phone number callback

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.onInputChanged, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.offWhiteOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              // Store only the number part in controller (without country code)
              controller.text = number.parseNumber();

              // Pass full phone number object to parent
              if (onInputChanged != null) {
                onInputChanged!(number);
              }

              if (onChanged != null) {
                onChanged!(number.parseNumber());
              }
            },
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              showFlags: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            initialValue: PhoneNumber(isoCode: 'PK'),
            textFieldController: controller,
            formatInput: false, // CHANGED: false so country code doesn't show in field
            cursorColor: AppColors.primaryTealOf(context),
            inputBorder: InputBorder.none,
            keyboardType: TextInputType.number,
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
