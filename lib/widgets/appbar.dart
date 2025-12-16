import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const Appbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        text,
        style: TextStyle(
          color: AppColors.offWhiteOf(context),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppColors.slateGrayOf(context).withValues(alpha: 0.8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
