import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../../../models/setting/user_profile.dart';
import '../../../viewmodels/setting_viewmodel/setting_vm.dart';
import 'Widgets/logout.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<String> avatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar6.png',
    'assets/avatars/avatar7.png',
    'assets/avatars/avatar8.png',
    'assets/avatars/avatar9.png',
    'assets/avatars/avatar10.png',
    'assets/avatars/avatar11.png',
    'assets/avatars/avatar12.png',
    'assets/avatars/avatar13.png',
    'assets/avatars/avatar14.png',
    'assets/avatars/avatar15.png',
    'assets/avatars/avatar16.png',
    'assets/avatars/avatar17.png',
    'assets/avatars/avatar18.png',
    'assets/avatars/avatar19.png',
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   // Screen open hone pe fresh data load karo
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(settingsViewModelProvider.notifier).refreshUserData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.offWhiteOf(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              showLogoutDialog(context, ref);
            },
            icon: Icon(Icons.logout, color: AppColors.pinkOf(context)),
          ),
        ],
      ),
      body: userProfileState.when(
        data: (profile) => _buildContent(profile, viewModel),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(UserProfile profile, SettingsViewModel viewModel) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(profile),
                  const SizedBox(height: 24),
                  _buildSectionHeader('APP PREFERENCES', Icons.tune),
                  const SizedBox(height: 12),
                  _buildPreferencesCard(viewModel),
                  // const SizedBox(height: 24),
                  //Todo: Notification Section
                  // _buildSectionHeader(
                  //   'NOTIFICATIONS',
                  //   Icons.notifications_active,
                  // ),
                  // const SizedBox(height: 12),
                  // _buildNotificationsCard(viewModel),
                  const SizedBox(height: 24),
                  _buildSectionHeader('ACCOUNT', Icons.person),
                  const SizedBox(height: 12),
                  _buildAccountCard(),
                  const SizedBox(height: 24),
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
    );
  }

  Widget _buildProfileCard(UserProfile profile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.slateGrayOf(context).withValues(alpha:0.7),
            AppColors.slateGrayOf(context).withValues(alpha:0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGrayOf(context).withValues(alpha:0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showAvatarSelector,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.offWhiteOf(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.offWhiteOf(context).withValues(alpha:0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  profile.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.slateGrayOf(context).withValues(alpha:0.7),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha:0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
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
          IconButton(
            onPressed: _showEditProfileDialog,
            icon: const Icon(Icons.edit, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(SettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _buildSettingTile(
        icon: Icons.palette_outlined,
        iconColor: const Color(0xFFFFB74D),
        iconBgColor: const Color(0xFFFFB74D).withValues(alpha:0.1),
        title: 'Theme',
        subtitle: viewModel.preferences.theme == 'light'
            ? 'Light Mode'
            : 'Dark Mode',
        onTap: _showThemeDialog,
        showDivider: false,
      ),
    );
  }

  Widget _buildNotificationsCard(SettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active,
            iconColor: AppColors.primaryTealOf(context).withValues(alpha: 0.7),
            iconBgColor: AppColors.primaryTealOf(
              context,
            ).withValues(alpha: 0.1),
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: viewModel.preferences.notificationsEnabled,
            onChanged: (v) {
              ref
                  .read(settingsViewModelProvider.notifier)
                  .updateNotifications(v);
              setState(() {});
            },
            showDivider: true,
          ),
          _buildSwitchTile(
            icon: Icons.alarm,
            iconColor: AppColors.warmAmberOf(context).withValues(alpha: 0.7),
            iconBgColor: AppColors.warmAmberOf(context).withValues(alpha: 0.1),
            title: 'Payment Reminders',
            subtitle: 'Get notified before due dates',
            value: viewModel.preferences.reminderAlerts,
            onChanged: (v) {
              ref.read(settingsViewModelProvider.notifier).updateReminders(v);
              setState(() {});
            },
            showDivider: true,
          ),
          _buildSwitchTile(
            icon: Icons.warning_amber,
            iconColor: AppColors.pinkOf(context).withValues(alpha: 0.7),
            iconBgColor: AppColors.pinkOf(context).withValues(alpha: 0.1),
            title: 'Overdue Alerts',
            subtitle: 'Alert for overdue payments',
            value: viewModel.preferences.overdueAlerts,
            onChanged: (v) {
              ref
                  .read(settingsViewModelProvider.notifier)
                  .updateOverdueAlerts(v);
              setState(() {});
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
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.lock_outline,
            iconColor: const Color(0xFF6366F1).withValues(alpha: 0.7),
            iconBgColor: const Color(0xFF6366F1).withValues(alpha:0.1),
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              Navigator.pushNamed(context, '/change-password');
            },
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.delete_outline,
            iconColor: AppColors.pinkOf(context).withValues(alpha: 0.7),
            iconBgColor: AppColors.pinkOf(context).withValues(alpha: 0.1),
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () {
              Navigator.pushNamed(context, '/delete-account');
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.help_outline,
            iconColor: const Color(0xFF6B7FFF).withValues(alpha:0.7),
            iconBgColor: const Color(0xFF6B7FFF).withValues(alpha:0.1),
            title: 'Help & Support',
            subtitle: 'Get help with KistFlow',
            onTap: () => Navigator.pushNamed(context, '/help'),
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFF8B5CF6).withValues(alpha:0.7),
            iconBgColor: const Color(0xFF8B5CF6).withValues(alpha:0.1),
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () => Navigator.pushNamed(context, '/privacy'),
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.primaryTeal.withValues(alpha:0.7),
            iconBgColor: AppColors.primaryTeal.withValues(alpha:0.1),
            title: 'Terms & Conditions',
            subtitle: 'Terms of service',
            onTap: () => Navigator.pushNamed(context, '/terms'),
            showDivider: true,
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            iconColor: AppColors.warmAmber.withValues(alpha:0.7),
            iconBgColor: AppColors.warmAmber.withValues(alpha:0.1),
            title: 'App Version',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            showDivider: false,
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
            color: AppColors.primaryTealOf(context).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryTealOf(context)),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreyOf(context),
            letterSpacing: 1,
          ),
        ),
      ],
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
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slateGrayOffWhiteOf(
                              context,
                            ).withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkGreyOf(
                              context,
                            ).withValues(alpha:0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.darkGrey.withValues(alpha:0.5),
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
              color: AppColors.darkGreyOf(context).withValues(alpha: 0.2),
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
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateGrayOffWhiteOf(
                          context,
                        ).withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGreyOf(context).withValues(alpha:0.7),
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
                  activeTrackColor: iconColor.withValues(alpha:0.5),
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
              color: AppColors.darkGreyOf(context).withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }

  // =================== DIALOGS (Original) ===================

  void _showEditProfileDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.offWhiteOf(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.slateGrayOf(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.slateGrayOffWhiteOf(context),
              ),
            ),
            const SizedBox(height: 24),
            _buildEditOption(
              icon: Icons.person_outline,
              title: 'Change Profile Picture',
              subtitle: 'Select a new avatar',
              color: AppColors.primaryTealOf(context),
              onTap: () {
                Navigator.pop(context);
                _showAvatarSelector();
              },
            ),
            const SizedBox(height: 12),
            _buildEditOption(
              icon: Icons.edit_outlined,
              title: 'Change Name',
              subtitle: 'Update your display name',
              color: const Color(0xFF6B7FFF),
              onTap: () {
                Navigator.pop(context);
                _showChangeNameDialog();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEditOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGrey.withValues(alpha:0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  void _showAvatarSelector() {
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final profile = ref.read(settingsViewModelProvider).value;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: AppColors.offWhiteOf(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.slateGrayOf(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Avatar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.slateGrayOffWhiteOf(context),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final avatar = avatars[index];
                  final isSelected = avatar == profile?.avatar;
                  return GestureDetector(
                    onTap: () async {
                      await viewModel.updateAvatar(avatar);
                      if (mounted) Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryTealOf(context)
                              : Colors.grey.shade300,
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryTealOf(
                                    context,
                                  ).withValues(alpha:0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.slateGrayOf(
                                context,
                              ).withValues(alpha:0.5),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeNameDialog() {
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final profile = ref.read(settingsViewModelProvider).value;
    final nameController = TextEditingController(text: profile?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Change Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.slateGrayOffWhiteOf(context),
          ),
        ),
        content: TextField(
          controller: nameController,
          cursorColor: AppColors.primaryTealOf(context),
          decoration: InputDecoration(
            hint: Text('Enter new name'),
            hintStyle: TextStyle(
              color: AppColors.offBlackOf(context),
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.lightGreyOf(context),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryTeal, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryTealOf(context),
                width: 1.5,
              ),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.slateGrayOffWhiteOf(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await viewModel.updateUserName(newName);
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTealOf(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Save', style: TextStyle(color: AppColors.offWhite)),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.offWhiteOf(context),
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
                    color: AppColors.slateGrayOf(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGrayOffWhiteOf(context),
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                'light',
                'Light Mode',
                'Always use light theme',
                Icons.wb_sunny,
                const Color(0xFFFFB74D),
                viewModel,
              ),
              _buildThemeOption(
                'dark',
                'Dark Mode',
                'Always use dark theme',
                Icons.dark_mode,
                const Color(0xFF4A5568),
                viewModel,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    String themeValue,
    String theme,
    String description,
    IconData icon,
    Color color,
    SettingsViewModel viewModel,
  ) {
    bool isSelected = viewModel.preferences.theme == themeValue;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? color.withValues(alpha:0.1)
            : AppColors.lightGreyOf(context),
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
            color: isSelected ? color : AppColors.lightGreyOf(context),
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
            color: isSelected
                ? color
                : AppColors.slateGrayOffWhiteOf(context).withValues(alpha: 0.7),
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkGreyOf(context).withValues(alpha: 0.7),
          ),
        ),
        trailing: isSelected ? Icon(Icons.check_circle, color: color) : null,
        onTap: () async {
          await viewModel.updateTheme(themeValue);
          setState(() {});
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }
}
