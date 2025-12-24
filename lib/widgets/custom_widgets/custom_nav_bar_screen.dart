import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kistflow/helpers/ui_helper.dart';
import 'package:kistflow/views/screens/customer/add_customer_screen.dart';
import 'package:kistflow/views/screens/dashboard/dashboard_screen.dart';
import 'package:kistflow/views/screens/report/report_screen.dart';
import 'package:kistflow/views/screens/settings/setting_screen.dart';
import 'package:kistflow/views/screens/customer/view_customer_screen.dart';

import '../../core/app_colors.dart';
import '../../viewmodels/bottom_nav_vm.dart';

class CustomNavBarScreen extends ConsumerWidget {
  const CustomNavBarScreen({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    DashboardScreen(),
    ViewCustomerScreen(),
    AddCustomerScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navIndexProvider);
    final backHandler = ref.read(backHandlerProvider);

    return WillPopScope(
      onWillPop: () async {
        if (navIndex != 0) {
          ref.read(navIndexProvider.notifier).state = 0;
          return false;
        } else {
          if (backHandler.canExit()) {
            return true;
          }
           UIHelper.showSnackBar(
             context,
              "Press again to exit",
             isError: false,
          );
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkOf(context),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _pages[navIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavBar(context, ref, navIndex),
            ),
            _buildFloatingButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, WidgetRef ref, int navIndex) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.darkOf(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            _navItem(ref, Icons.home_outlined, 0, navIndex),
            _navItem(ref, CupertinoIcons.person_3_fill, 1, navIndex),
            const SizedBox(width: 60),
            _navItem(ref, FontAwesomeIcons.lineChart, 3, navIndex),
            _navItem(ref, Icons.settings, 4, navIndex),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
      WidgetRef ref, IconData icon, int index, int navIndex) {
    final isSelected = navIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => ref.read(navIndexProvider.notifier).state = index,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white54,
            size: isSelected ? 28 : 24,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: 48,
      left: MediaQuery.of(context).size.width / 2 - 30,
      child: GestureDetector(
        onTap: () => ref.read(navIndexProvider.notifier).state = 2,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.darkOf(context), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: AppColors.slateGray, size: 30),
        ),
      ),
    );
  }
}