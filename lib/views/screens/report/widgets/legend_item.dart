import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.darkGreyOf(context)),
        ),
      ],
    );
  }
}
