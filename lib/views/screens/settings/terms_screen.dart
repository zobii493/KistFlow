import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/appbar.dart';
import 'Widgets/info_card.dart';
import 'Widgets/policy_item.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Terms & Conditions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryTealOf(context).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined,
                      size: 40, color: AppColors.primaryTealOf(context)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Please read these Terms & Conditions carefully before using KistFlow. By using the app, you agree to follow and comply with these rules.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.darkGreyOf(context),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info Card with T&C Items
            InfoCard(
              icon: Icons.rule,
              color: AppColors.primaryTealOf(context),
              title: 'Terms of Service',
              children: const [
                PolicyItem(
                  number: '1',
                  title: 'Acceptance of Terms',
                  description:
                  'By using KistFlow, you agree to comply with these Terms & Conditions. Please read them carefully before using the app.',
                ),
                PolicyItem(
                  number: '2',
                  title: 'User Responsibilities',
                  description:
                  'Users are responsible for providing accurate customer information, maintaining proper records, and using the app lawfully and ethically.',
                ),
                PolicyItem(
                  number: '3',
                  title: 'Service Availability',
                  description:
                  'We strive to maintain uninterrupted service, but occasional maintenance or downtime may occur. Users are advised to plan accordingly.',
                ),
                PolicyItem(
                  number: '4',
                  title: 'Limitation of Liability',
                  description:
                  'KistFlow shall not be held liable for any direct or indirect losses arising from the use of the app, including financial or operational losses.',
                ),
                PolicyItem(
                  number: '5',
                  title: 'Data Accuracy',
                  description:
                  'While we take measures to secure and maintain data integrity, users are responsible for verifying and backing up their information.',
                ),
                PolicyItem(
                  number: '6',
                  title: 'Modifications to Terms',
                  description:
                  'We reserve the right to modify these Terms & Conditions at any time. Continued use of the app after changes implies acceptance.',
                ),
                PolicyItem(
                  number: '7',
                  title: 'Termination',
                  description:
                  'KistFlow may suspend or terminate accounts violating these terms. Users may also delete their account at any time, subject to the deletion policy.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Footer / Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryTealOf(context).withValues(alpha:0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Note: These Terms & Conditions are designed to protect both the user and the app provider. For any questions or clarifications, contact support via email or WhatsApp.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGreyOf(context).withValues(alpha:0.9),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
