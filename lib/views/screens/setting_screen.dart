import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedTheme = 'System Default';
  bool notificationsEnabled = true;
  bool reminderAlerts = true;
  bool overdueAlerts = true;
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.offWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Card
                    _buildProfileCard(),
                    const SizedBox(height: 24),

                    // App Preferences Section
                    _buildSectionHeader('APP PREFERENCES', Icons.tune),
                    const SizedBox(height: 12),
                    _buildPreferencesCard(),
                    const SizedBox(height: 24),

                    // Notifications Section
                    _buildSectionHeader('NOTIFICATIONS', Icons.notifications_active),
                    const SizedBox(height: 12),
                    _buildNotificationsCard(),
                    const SizedBox(height: 24),

                    // Account Section
                    _buildSectionHeader('ACCOUNT', Icons.person),
                    const SizedBox(height: 12),
                    _buildAccountCard(),
                    const SizedBox(height: 24),

                    // About Section
                    _buildSectionHeader('ABOUT', Icons.info),
                    const SizedBox(height: 12),
                    _buildAboutCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.slateGray.withOpacity(0.7),
            AppColors.slateGray.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.slateGray.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zohaib Hassan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'zohaib@email.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Premium Member',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.palette_outlined,
            iconColor: Color(0xFFFFB74D),
            iconBgColor: Color(0xFFFFB74D).withOpacity(0.1),
            title: 'Theme',
            subtitle: selectedTheme,
            onTap: () => _showThemeDialog(),
            showDivider: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active,
            iconColor: AppColors.pink.withValues(alpha: 0.7),
            iconBgColor: AppColors.pink.withValues(alpha: 0.1),
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
            showDivider: true,
          ),
          _buildSwitchTile(
            icon: Icons.alarm,
            iconColor: AppColors.warmAmber.withValues(alpha: 0.7),
            iconBgColor: AppColors.warmAmber.withValues(alpha: 0.1),
            title: 'Payment Reminders',
            subtitle: 'Get notified before due dates',
            value: reminderAlerts,
            onChanged: (value) {
              setState(() {
                reminderAlerts = value;
              });
            },
            showDivider: true,
          ),
          _buildSwitchTile(
            icon: Icons.warning_amber,
            iconColor: AppColors.pink.withValues(alpha: 0.7),
            iconBgColor: AppColors.pink.withValues(alpha: 0.1),
            title: 'Overdue Alerts',
            subtitle: 'Alert for overdue payments',
            value: overdueAlerts,
            onChanged: (value) {
              setState(() {
                overdueAlerts = value;
              });
            },
            showDivider: true,
          ),
          _buildSwitchTile(
            icon: Icons.volume_up,
            iconColor: Color(0xFF8B5CF6).withValues(alpha: 0.7),
            iconBgColor: Color(0xFF8B5CF6).withOpacity(0.1),
            title: 'Sound',
            subtitle: 'Enable notification sounds',
            value: soundEnabled,
            onChanged: (value) {
              setState(() {
                soundEnabled = value;
              });
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.lock_outline,
            iconColor: Color(0xFF6366F1).withValues(alpha: 0.7),
            iconBgColor: Color(0xFF6366F1).withOpacity(0.1),
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {},
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.backup_outlined,
            iconColor: AppColors.primaryTeal.withValues(alpha: 0.7),
            iconBgColor: AppColors.primaryTeal.withValues(alpha: 0.1),
            title: 'Backup & Restore',
            subtitle: 'Backup your data',
            onTap: () {},
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.delete_outline,
            iconColor: AppColors.pink.withValues(alpha: 0.7),
            iconBgColor: AppColors.pink.withValues(alpha: 0.1),
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () {},
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.help_outline,
            iconColor: Color(0xFF6B7FFF).withValues(alpha: 0.7),
            iconBgColor: Color(0xFF6B7FFF).withOpacity(0.1),
            title: 'Help & Support',
            subtitle: 'Get help and support',
            onTap: () {},
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: Color(0xFF8B5CF6).withValues(alpha: 0.7),
            iconBgColor: Color(0xFF8B5CF6).withOpacity(0.1),
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {},
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.primaryTeal.withValues(alpha: 0.7),
            iconBgColor: AppColors.primaryTeal.withValues(alpha: 0.1),
            title: 'Terms & Conditions',
            subtitle: 'Read terms and conditions',
            onTap: () {},
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            iconColor: AppColors.warmAmber.withValues(alpha: 0.7),
            iconBgColor: AppColors.warmAmber.withValues(alpha: 0.1),
            title: 'App Version',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slateGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkGrey.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.darkGrey.withOpacity(0.5),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade100,
            ),
          ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGrey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: iconColor,
                  activeTrackColor: iconColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade100,
            ),
          ),
      ],
    );
  }

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption('System Default', 'Follow system settings', Icons.brightness_auto, Color(0xFF6B7FFF)),
              _buildThemeOption('Light Mode', 'Always use light theme', Icons.wb_sunny, Color(0xFFFFB74D)),
              _buildThemeOption('Dark Mode', 'Always use dark theme', Icons.dark_mode, Color(0xFF4A5568)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String theme, String description, IconData icon, Color color) {
    bool isSelected = selectedTheme == theme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        title: Text(
          theme,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? color : AppColors.slateGray,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkGrey,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: color)
            : null,
        onTap: () {
          setState(() {
            selectedTheme = theme;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}