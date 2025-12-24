import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/views/screens/customer/payment_history_screen.dart';
import 'package:kistflow/widgets/appbar.dart';
import 'package:kistflow/widgets/horizontal_doted_line.dart';

import '../../../core/app_colors.dart';
import '../../../helpers/ui_helper.dart';
import '../../../models/customer.dart';
import '../../../viewmodels/customer_viewmodel/customer_detail_vm.dart';
import '../../../viewmodels/customer_viewmodel/view_customer_vm.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  // final Customer customer;
  final String customerId;

  const CustomerDetailScreen({
    Key? key,
    // required this.customer,
    required this.customerId,
  }) : super(key: key);

  @override
  ConsumerState<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  bool _isLoading = false;
  late ConfettiController _confettiController;


  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Unpaid':
        return const Color(0xFFEF4444);
      case 'Upcoming':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFDC2626);
      case 'Completed':
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  void _showPartialPaymentDialog(Customer customer, CustomerDetailViewModel vm) {
    final TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.offBlackOf(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTealOf(context).withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primaryTealOf(context),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Monthly Payment',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.slateGrayOf(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Update installment amount',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.darkGreyOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Current Installment Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.offWhiteOf(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.darkGreyOf(context).withValues(alpha:0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Monthly',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkGreyOf(context),
                          ),
                        ),
                        Text(
                          'Rs. ${customer.monthlyInstallment}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateGrayOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Field
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slateGrayOf(context),
                    ),
                    decoration: InputDecoration(

                      hint: Text('Payment Amount'),
                      hintStyle: TextStyle(
                        color: AppColors.darkGreyOf(context),
                      ),
                      prefixIcon: Icon(
                        Icons.payments,
                        color: AppColors.primaryTealOf(context),
                      ),
                      prefixText: 'Rs. ',
                      prefixStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateGrayOf(context),
                      ),
                      filled: true,
                      fillColor: AppColors.offWhiteOf(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.darkGreyOf(context).withValues(alpha:0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryTealOf(context),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFEF4444),
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFEF4444),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: AppColors.darkGreyOf(context).withValues(alpha:0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              double paidAmount = double.parse(_controller.text);

                              vm.markPartialPayment(paidAmount);

                              Navigator.pop(context);

                              UIHelper.showSnackBar(
                                context,
                                "Payment updated successfully!",
                                isError: false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primaryTealOf(context),
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
                                'Submit',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(customerProvider)
        .firstWhere((c) => c.id == widget.customerId);

    final vm = ref.watch(customerDetailVMProvider(customer));

    double totalPrice = double.parse(vm.customer.totalPrice.replaceAll(',', ''));
    double totalPaid = double.parse(vm.customer.totalPaid.replaceAll(',', ''));
    double progressPercentage = (totalPaid / totalPrice) * 100;

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Customer Details',),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Item Details Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.offBlackOf(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.06),
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
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.slateGrayOf(context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(customer.status).withValues(alpha:0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        customer.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(customer.status),
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
                                    color: AppColors.darkGreyOf(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.creditcard,
                                      size: 14,
                                      color: AppColors.darkGreyOf(context),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      customer.cnic,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkGreyOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 14,
                                      color: AppColors.darkGreyOf(context),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      customer.phoneNumber,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkGreyOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: AppColors.darkGreyOf(context),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        customer.address,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.darkGreyOf(context),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: customer.imagePath != null && customer.imagePath!.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            customer.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.devices,
                                size: 40,
                                color: AppColors.darkGreyOf(context),
                              );
                            },
                          ),
                        )
                            : Icon(
                          Icons.devices,
                          size: 40,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      HorizontalDotedLine(),
                      const SizedBox(height: 16),
                      Text(
                        customer.itemName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slateGrayOf(context),
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
                                  color: AppColors.darkGreyOf(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs. ${customer.totalPrice}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.slateGrayOf(context),
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
                                  color: AppColors.darkGreyOf(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs. ${customer.deposit}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.slateGrayOf(context),
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
                    color: AppColors.offBlackOf(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGrayOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      HorizontalDotedLine(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Paid',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            'Rs. ${customer.totalPaid}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTealOf(context),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryTealOf(context),
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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            'Rs. ${customer.remaining}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warmAmber,
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
                    color: AppColors.offBlackOf(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.06),
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
                          Text(
                            'Payment Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
                            ),
                          ),
                          Spacer(),
                          if(customer.status !="Completed")
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit_payment',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16,color: AppColors.primaryTealOf(context),),
                                      SizedBox(width: 8),
                                      Text('Edit Payment'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit_payment') {
                                  _showPartialPaymentDialog(customer, vm);
                                }
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      HorizontalDotedLine(),
                      const SizedBox(height: 20),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Installment',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTealOf(context).withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Rs. ${customer.monthlyInstallment}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTealOf(context),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 4),

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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            customer.installmentMonths,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            customer.takenDate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            customer.endDate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slateGrayOf(context),
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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warmAmber.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              customer.nextDueDate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warmAmber,
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
                      // HIDE BUTTON IF STATUS IS "Completed"
                      if (customer.status != "Completed")
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                              setState(() => _isLoading = true);
                              try {
                                final wasCompletedBefore = customer.status == "Completed";

                                await vm.markInstallmentPaid();
                                if (!wasCompletedBefore && vm.customer.status == "Completed") {
                                  _confettiController.play();
                                }


                                if (!mounted) return;

                                UIHelper.showSnackBar(
                                  context,
                                  "Payment marked successfully!",
                                  isError: false,
                                );
                              } catch (e) {
                                if (!mounted) return;

                                UIHelper.showSnackBar(
                                  context,
                                  "Failed to mark payment: $e",
                                  isError: true,
                                );
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTealOf(context).withValues(alpha: 0.8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Row(
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
                      if (customer.status != "Completed") const SizedBox(height: 12),
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
                            backgroundColor: AppColors.offWhiteOf(context),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 20, color: AppColors.slateGrayOf(context)),
                              SizedBox(width: 8),
                              Text(
                                'Show History',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.slateGrayOf(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // CustomerElevatedButton(text: 'Send Reminder', icon: Icons.notifications, onPressed: (){
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => PaymentReminderScreen(customer: customer),
                      //     ),
                      //   );
                      // }, backgroundColor:AppColors.warmAmberOf(context).withValues(alpha: 0.8),)
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
              gravity: 0.3,
            ),
          ),
          ],
      ),
    );
  }
}