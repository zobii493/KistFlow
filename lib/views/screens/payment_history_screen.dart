import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/customer.dart';
import '../../widgets/appbar.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final Customer customer;

  const PaymentHistoryScreen({Key? key, required this.customer})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cumulativePaid = 0;
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Payment History'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          ...List.generate(customer.history.length, (index) {
            final item = customer.history[index];

            // Convert to number
            double paidThisMonth = double.parse(item['paid']);
            double remaining = double.parse(item['remaining']);
            cumulativePaid += paidThisMonth;

            double totalPrice = double.parse(
              customer.totalPrice.replaceAll(',', ''),
            );
            double progress = (cumulativePaid / totalPrice).clamp(
              0,
              1,
            ); // 0.0 - 1.0

            return Container(
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: AppColors.offBlackOf(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.darkGreyOf(context).withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dot + Line
                    Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTealOf(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index != customer.history.length - 1)
                          Container(
                            width: 2,
                            height: 60,
                            color: AppColors.darkGreyOf(
                              context,
                            ).withOpacity(0.4),
                          ),
                      ],
                    ),

                    const SizedBox(width: 18),

                    // Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['date'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slateGrayOf(context),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Paid",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGreyOf(context),
                                ),
                              ),
                              Text(
                                "Rs. ${cumulativePaid.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTealOf(
                                    context,
                                  ).withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Remaining",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGreyOf(context),
                                ),
                              ),
                              Text(
                                "Rs. ${remaining.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warmAmberOf(context),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTealOf(context),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
