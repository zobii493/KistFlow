import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/customer.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final Customer customer;

  const PaymentHistoryScreen({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.slateGray,
        centerTitle: true,
        title: const Text(
          "Payment History",
          style: TextStyle(
            color: AppColors.offWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          ...List.generate(
            customer.history.length,
                (index) {
              final item = customer.history[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.solid,
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
                      // ---- Timeline Dot ----
                      Column(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (index != customer.history.length - 1)
                            Container(
                              width: 2,
                              height: 60,
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),

                      const SizedBox(width: 18),

                      // ---- Payment Info ----
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['date'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slateGray,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Paid Amount",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                Text(
                                  "Rs. ${item['paid']}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Remaining",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                Text(
                                  "Rs. ${item['remaining']}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.warmAmber,
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
                                widthFactor: item['progress'], // 0.0 - 1.0
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryTeal,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
