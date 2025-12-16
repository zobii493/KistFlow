import 'package:flutter/material.dart';
import 'package:kistflow/core/app_colors.dart';

class UIHelper {
  static void showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    OverlayEntry entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 16, // top margin
        left: 16,
        right: 16,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? AppColors.pinkOf(context) : AppColors.primaryTealOf(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);

    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }
}
