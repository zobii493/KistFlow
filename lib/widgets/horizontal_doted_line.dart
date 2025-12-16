import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class HorizontalDotedLine extends StatelessWidget {
  const HorizontalDotedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              '----------------------',
              style: TextStyle(
                letterSpacing: 8,
                fontSize: 24,
                color: AppColors.darkGreyOf(context).withValues(alpha: 0.7),
              ),
            ),
          ),
          Positioned(
            left: -29,
            top: 5,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.offWhiteOf(context).withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -29,
            top: 5,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.offWhiteOf(context).withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
