import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../viewmodels/customer_viewmodel/bottom_nav_vm.dart';
Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.logout, color: AppColors.pink),
          SizedBox(width: 12),
          Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Text(
        'Are you sure you want to logout from your account?',
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.darkGrey)),
        ),
        ElevatedButton(
          onPressed: () async {
            await authService.signOut();
            if (!context.mounted) return;
            ref.read(navIndexProvider.notifier).state = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
                  (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
