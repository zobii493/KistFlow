import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/appbar.dart';
import 'Widgets/faq_item.dart';
import 'Widgets/info_card.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Help & Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Contact Info
            InfoCard(
              icon: Icons.help_outline,
              color: const Color(0xFF6B7FFF),
              title: 'Need Help?',
              children: const [
                _InfoItem(icon: '📧', text: 'Email: kistflow5@gmail.com'),
                _InfoItem(icon: '📱', text: 'WhatsApp: +92 341 9466773'),
              ],
            ),

            const SizedBox(height: 20),

            /// FAQs Heading
            Row(
              children: [
                Icon(Icons.quiz, color: AppColors.darkGreyOf(context)),
                const SizedBox(width: 12),
                Text(
                  'FAQs',
                  style: TextStyle(
                    color: AppColors.darkGreyOf(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Account & Login
            InfoCard(
              icon: Icons.lock_outline,
              color: AppColors.primaryTealOf(context),
              title: 'Account & Login',
              children: const [
                FaqItem(
                  question: 'How do I create an account?',
                  answer:
                      'To create an account, open the app and tap on Sign Up. Enter your email address, create a password, and complete the registration process by following the on-screen instructions.',
                ),
                FaqItem(
                  question: 'How do I log in to my account?',
                  answer:
                      'Tap on Login, enter your registered email address and password, then press Login to access your account.',
                ),
                FaqItem(
                  question: 'What should I do if I forget my password?',
                  answer:
                      'If you forget your password, tap on Forgot Password on the login screen. You can reset your password using OTP verification sent to your registered email.',
                ),
                FaqItem(
                  question: 'Can I reset my password using OTP?',
                  answer:
                      'Yes. The app supports OTP-based password recovery. When you select Forgot Password, an OTP will be sent to your registered email address. Enter the OTP to set a new password.',
                ),
                FaqItem(
                  question: 'Can I use the app without creating an account?',
                  answer:
                      'No. You must create an account to use the app. Account registration is required to securely store and manage your data.',
                ),
                FaqItem(
                  question:
                      'I signed up but did not receive the email verification code. What should I do?',
                  answer:
                      "After signing up, a verification code is sent to your registered email address. If you do not see the email in your inbox, please check your Spam or Junk folder. The verification email is usually delivered there. Make sure to verify your email to activate your account.",
                ),
                FaqItem(
                  question: 'How do I log out of the app?',
                  answer:
                      'To log out, go to the Settings screen and tap on Logout. Confirm your action to securely sign out of your account.',
                ),
                FaqItem(question: 'How do I delete my account?', answer: ''),
              ],
            ),
            const SizedBox(height: 16),
            InfoCard(
              icon: Icons.dashboard_outlined,
              color: AppColors.slateGrayOf(context),
              title: 'App Usage & Features',
              children: [
                FaqItem(
                  question: 'What is this app used for?',
                  answer:
                      'This app is designed to help users manage customers, track installment payments, monitor due and overdue payments, and view detailed business reports — all in one place. It is ideal for small businesses and individuals who want to manage payment records efficiently.',
                ),
                FaqItem(
                  question: 'What features are available on the Dashboard?',
                  answer:
                      'The Dashboard provides an overview of your business activities, including total customers, paid and unpaid amounts, overdue payments, upcoming installments, and visual charts for quick insights.',
                ),
                FaqItem(
                  question: 'How do I add a customer record?',
                  answer:
                      'To add a customer, tap on the Add Customer button from the bottom menu. Enter the customer’s details and save the information. The customer will then appear in your customer list.',
                ),
                FaqItem(
                  question: 'What do Paid, Unpaid, and Overdue mean?',
                  answer:
                      'Paid: Installments that have been successfully paid.\nUnpaid: Installments that are due but not yet paid.\nOverdue: Installments that have passed their due date and remain unpaid.',
                ),
                FaqItem(
                  question: 'How can I view reports?',
                  answer:
                      'To view reports, go to the Reports section from the bottom navigation menu. Here, you can see graphical and detailed reports related to payments, customers, and overall performance.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Payments & Reminders
            InfoCard(
              icon: Icons.notifications_active_outlined,
              color: AppColors.warmAmberOf(context),
              title: 'Payments & Reminders',
              children: const [
                FaqItem(
                  question: 'What is a payment reminder?',
                  answer:
                      'A payment reminder notifies you before a payment is due so you do not miss it.',
                ),
                FaqItem(
                  question: 'How do notifications work?',
                  answer:
                      'Notifications alert you about upcoming payments, overdue installments, and important updates.',
                ),
                FaqItem(
                  question: 'What are overdue alerts?',
                  answer:
                      'Overdue alerts notify you when a payment has passed its due date.',
                ),
                FaqItem(
                  question: 'Can I turn off reminders?',
                  answer:
                      'Yes. You can enable or disable reminders from Settings > Notifications.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Settings & Profile
            InfoCard(
              icon: Icons.settings_outlined,
              color: AppColors.skyBlueOf(context),
              title: 'Settings & Profile',
              children: const [
                FaqItem(
                  question: 'How do I update my profile?',
                  answer:
                      'Go to Settings and select Edit Profile to update your details.',
                ),
                FaqItem(
                  question: 'How do I change my name or avatar?',
                  answer:
                      'You can change your name and profile picture from Settings > Edit Profile.',
                ),
                FaqItem(
                  question: 'How do I switch Dark or Light mode?',
                  answer:
                      'Go to Settings > Theme and select Dark or Light mode.',
                ),
                FaqItem(
                  question: 'How do I enable or disable notifications?',
                  answer:
                      'Notification settings can be managed from Settings > Notifications.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Data & Security
            InfoCard(
              icon: Icons.security_outlined,
              color: AppColors.primaryTealOf(context),
              title: 'Data & Security',
              children: const [
                FaqItem(
                  question: 'Is my data safe?',
                  answer:
                      'Yes. Your data is securely stored using standard security practices.',
                ),
                FaqItem(
                  question: 'Is my data stored in the cloud?',
                  answer: 'Yes. Your data is securely saved in the cloud.',
                ),
                FaqItem(
                  question: 'Can I delete my data?',
                  answer:
                      'Yes. You can delete customers, records, or your entire account.',
                ),
                FaqItem(
                  question: 'What happens if I delete my account?',
                  answer:
                      'Deleting your account permanently removes all your data and cannot be undone.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Technical & General
            InfoCard(
              icon: Icons.build_outlined,
              color: AppColors.pinkOf(context),
              title: 'Technical & General',
              children: const [
                FaqItem(
                  question: 'What should I do if the app crashes?',
                  answer:
                      'Restart the app and ensure you are using the latest version.',
                ),
                FaqItem(
                  question: 'What if notifications are not working?',
                  answer: 'Check app and device notification settings.',
                ),
                FaqItem(
                  question: 'Is the app free to use?',
                  answer: 'Yes. The app is free to use.',
                ),
                FaqItem(
                  question: 'How can I contact support?',
                  answer:
                      'You can contact support via email or WhatsApp from the Help section.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.darkGreyOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
