import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kistflow/views/screens/add_customer_screen.dart';
import 'package:kistflow/views/screens/dashboard_screen.dart';
import 'package:kistflow/views/screens/report_screen.dart';
import 'package:kistflow/views/screens/setting_screen.dart';
import 'package:kistflow/views/screens/view_customer_screen.dart';

import '../../core/app_colors.dart';

class CustomNavBarScreen extends StatefulWidget {
  const CustomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<CustomNavBarScreen> createState() => _CustomNavBarScreenState();
}

class _CustomNavBarScreenState extends State<CustomNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ViewCustomerScreen(),
    const AddCustomerScreen(),
    const ReportScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          // Main content
          _pages[_selectedIndex],
          // Bottom navigation positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.slateGray,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    _buildNavItem(
                      icon: Icons.home_outlined,
                      index: 0,
                    ),
                    _buildNavItem(
                      icon: CupertinoIcons.person_3_fill,
                      index: 1,
                    ),
                    const SizedBox(width: 60),
                    _buildNavItem(
                      icon: FontAwesomeIcons.lineChart,
                      index: 3,
                    ),
                    _buildNavItem(
                      icon: Icons.settings,
                      index: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating action button
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 30,
            bottom: 48,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColors.slateGray,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onItemTapped(2),
                  customBorder: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.slateGray,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
              size: isSelected ? 28 : 24,
            ),
          ),
        ),
      ),
    );
  }
}