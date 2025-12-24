import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/appbar.dart';
import 'Widgets/info_card.dart';
import 'Widgets/policy_item.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InfoCard(
          icon: Icons.privacy_tip_outlined,
          color: const Color(0xFF8B5CF6),
          title: 'Your Privacy Matters',
          children: const [

            PolicyItem(
              number: '1',
              title: 'Information We Collect',
              description:
              'We collect only the information necessary to provide our services, including account details, customer records, and payment-related data entered by the user.',
            ),

            PolicyItem(
              number: '2',
              title: 'How We Use Your Information',
              description:
              'Your data is used solely to manage customers, track payments, generate reports, and improve app functionality.',
            ),

            PolicyItem(
              number: '3',
              title: 'Data Storage & Security',
              description:
              'All user data is securely stored and protected using industry-standard security practices and cloud infrastructure.',
            ),

            PolicyItem(
              number: '4',
              title: 'Data Sharing',
              description:
              'We do not sell, trade, or share your personal data with third parties unless required by law or with your explicit consent.',
            ),

            PolicyItem(
              number: '5',
              title: 'Your Rights & Control',
              description:
              'You have full control over your data and may access, update, or delete your information at any time from within the app.',
            ),

            PolicyItem(
              number: '6',
              title: 'Account Deletion',
              description:
              'If you choose to delete your account, all associated data will be permanently removed and cannot be recovered.',
            ),

            PolicyItem(
              number: '7',
              title: 'Policy Updates',
              description:
              'We may update this Privacy Policy from time to time. Any changes will be reflected within the app.',
            ),
          ],
        ),
      ),
    );
  }
}
