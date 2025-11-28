import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/customer.dart';

class PaymentReminderScreen extends StatelessWidget {
  final Customer customer;

  const PaymentReminderScreen({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFFF4E5),
                child: const Icon(
                  Icons.notifications_active,
                  size: 40,
                  color: Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 16),
          
              const Text(
                "Payment Reminder",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
                ),
              ),
          
              const SizedBox(height: 4),
          
              const Text(
                "Send a friendly reminder to your customer",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
              ),
          
              const SizedBox(height: 25),
          
              // Customer Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slateGray,
                      ),
                    ),
                    const SizedBox(height: 16),
          
                    _row("Name:", customer.name),
                    _row("Mobile:", customer.phoneNumber),
                    _row("Due Date:", customer.nextDueDate),
                    _row("Amount:", "Rs. ${customer.monthlyInstallment}"),
                  ],
                ),
              ),
          
              const SizedBox(height: 20),
          
              // Message Preview
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  """
Dear ${customer.name},

This is a friendly reminder that your monthly installment of Rs. ${customer.monthlyInstallment} for ${customer.itemName} is due on ${customer.nextDueDate}.

Please make the payment at your earliest convenience.

Thank you,
Kist Manager
""",
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.slateGray,
                  ),
                ),
              ),
          
              const SizedBox(height: 25),
          
              // Send SMS Reminder Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text(
                    "Send SMS Reminder",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              )),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.slateGray,
            ),
          ),
        ],
      ),
    );
  }
}
