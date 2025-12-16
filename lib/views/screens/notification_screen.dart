import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kistflow/widgets/appbar.dart';
import 'package:kistflow/widgets/auth/button.dart';
import 'package:kistflow/widgets/custom_card/customer_elevated_button.dart';

import '../../core/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Notifications'),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.offBlackOf(context),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warmAmberOf(context),
                            size: 32,
                          ),
                          Text(
                            'Payment Due Soon',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Customer: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' XYZ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Item: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' Mobile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Due Date: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' 09 Jan, 2026',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Default SMS:',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyCool(context),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '"Dear XYZ, your installment for the Mobile (RS. 10,000) is due on 09 Jan 2026. Please ensure timely payment. Thank you."',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: .italic,
                            color: AppColors.darkGreyOf(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomerElevatedButton(
                        text: 'Send Message',
                        icon: Icons.send,
                        onPressed: () {},
                        backgroundColor: AppColors.primaryTealOf(
                          context,
                        ).withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.offBlackOf(context),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_octagon,
                            color: AppColors.pinkOf(context),
                            size: 32,
                          ),
                          Text(
                            'OVERDUE INSTALLMENT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Customer: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' XYZ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Item: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' Mobile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Due Date: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            ' 09 Jan, 2026',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Default SMS:',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyCool(context),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '"Dear XYZ, your installment for the Mobile (RS. 10,000) is due on 09 Jan 2026. Please ensure timely payment. Thank you."',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: .italic,
                            color: AppColors.darkGreyOf(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomerElevatedButton(
                        text: 'Send Message',
                        icon: Icons.send,
                        onPressed: () {},
                        backgroundColor: AppColors.primaryTealOf(
                          context,
                        ).withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
