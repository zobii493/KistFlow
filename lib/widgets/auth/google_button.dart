import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const GoogleButton({
    Key? key,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.offWhiteOf(context),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.primaryTealOf(context),),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img.png', height: 30),
              const SizedBox(width: 8),
              Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyOf(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
