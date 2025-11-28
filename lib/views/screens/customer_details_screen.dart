import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kistflow/views/screens/payment_history_screen.dart';
import 'package:kistflow/views/screens/payment_reminder_screen.dart';

import '../../core/app_colors.dart';
import '../../models/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (customer.status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Unpaid':
        return const Color(0xFFEF4444);
      case 'Upcoming':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = double.parse(customer.totalPrice.replaceAll(',', ''));
    double totalPaid = double.parse(customer.totalPaid.replaceAll(',', ''));
    double progressPercentage = (totalPaid / totalPrice) * 100;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.slateGray,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Customer Details',
          style: TextStyle(
            color: AppColors.offWhite,
            fontSize: 20,
            fontWeight: .w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Item Details Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  customer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.slateGray,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor().withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    customer.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.fatherName,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.creditcard,
                                  size: 14,
                                  color: AppColors.darkGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(customer.cnic,style: TextStyle(fontSize: 13,
                                  color: AppColors.darkGrey,),),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: AppColors.darkGrey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  customer.phoneNumber,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.darkGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(customer.address,style: TextStyle(fontSize: 13,
                                  color: AppColors.darkGrey,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  //todo:add image otherwise empty
                  Center(
                    child: SizedBox(
                      child: Icon(
                        Icons.devices,
                        size: 40,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 30,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Center dashed line
                        Center(
                          child: Text(
                            '----------------------',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              letterSpacing: 8,
                              fontSize: 24,
                              color: AppColors.darkGrey.withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                        // Left circle (half outside)
                        Positioned(
                          left: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Right circle (half outside)
                        Positioned(
                          right: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    customer.itemName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slateGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs. ${customer.totalPrice}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGray,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Deposit',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs. ${customer.deposit}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment Progress Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slateGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Center dashed line
                        Center(
                          child: Text(
                            '----------------------',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              letterSpacing: 8,
                              fontSize: 24,
                              color: AppColors.darkGrey.withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                        // Left circle (half outside)
                        Positioned(
                          left: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Right circle (half outside)
                        Positioned(
                          right: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Paid',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        'Rs. ${customer.totalPaid}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressPercentage / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryTeal
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        'Rs. ${customer.remaining}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:  AppColors.warmAmber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment Information Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slateGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Center dashed line
                        Center(
                          child: Text(
                            '----------------------',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              letterSpacing: 8,
                              fontSize: 24,
                              color: AppColors.darkGrey.withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                        // Left circle (half outside)
                        Positioned(
                          left: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Right circle (half outside)
                        Positioned(
                          right: -29,
                          top: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly Installment',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rs. ${customer.monthlyInstallment}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Installment Months',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        customer.installmentMonths,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Taken Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        customer.takenDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        customer.endDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next Due Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:  AppColors.warmAmber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          customer.nextDueDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:  AppColors.warmAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Mark Installment Paid',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentHistoryScreen(customer: customer),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:  AppColors.offWhite,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.history, size: 20,color: AppColors.slateGray),
                          SizedBox(width: 8),
                          Text(
                            'Show History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slateGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentReminderScreen(customer: customer),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppColors.warmAmber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Send Reminder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
