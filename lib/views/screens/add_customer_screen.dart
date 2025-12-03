import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/data/customer_data.dart';
import 'package:kistflow/viewmodels/customer_viewmodel/view_customer_vm.dart';
import 'package:kistflow/widgets/horizontal_doted_line.dart';

import '../../core/app_colors.dart';
import '../../models/customer.dart';
import '../../viewmodels/customer_viewmodel/add_customer_viewmodel.dart';
import '../../widgets/auth/auth_button.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    Widget? suffixIcon,
    Color? fillColor,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorColor: AppColors.primaryTeal,
          readOnly: readOnly,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.slateGray, fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.darkGrey, fontSize: 14),
            filled: true,
            fillColor: fillColor ?? AppColors.lightGrey,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryTeal,
                width: 1.5,
              ),
            ),
            suffixIcon: suffixIcon,
          ),
          // Simple validation check for required fields
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  } // --- Widget Builders ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryTeal,
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.slateGray,
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInformation(AddCustomerViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildSectionHeader('Customer Information')),
          HorizontalDotedLine(),
          const SizedBox(height: 20),
          _buildLabel('Full Name'),
          _buildTextField(
            vm.fullName,
            hintText: 'Enter customer name',
            required: true,
          ),
          const SizedBox(height: 16),
          _buildLabel('Father Name'),
          _buildTextField(
            vm.fatherName,
            hintText: 'Enter father name',
            required: true,
          ),
          const SizedBox(height: 16),
          _buildLabel('CNIC'),
          _buildTextField(vm.cnic, hintText: 'xxxxx-xxxxxxx-x', required: true),
          const SizedBox(height: 16),
          _buildLabel('Mobile Number'),
          _buildTextField(
            vm.mobile,
            hintText: '03XX-XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
          ),
          const SizedBox(height: 16),
          _buildLabel('Address'),
          _buildTextField(
            vm.address,
            hintText: 'Enter complete address',
            maxLines: 4,
            required: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails(AddCustomerViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildSectionHeader('Item Details')),
          HorizontalDotedLine(),
          const SizedBox(height: 10),
          _buildLabel('Item Name', isRequired: true),
          _buildTextField(vm.itemName, hintText: 'e.g., Mobile'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Cash Price', isRequired: true),
                    _buildTextField(
                      vm.price,
                      hintText: 'Cash Price',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Advance', isRequired: true),
                    _buildTextField(
                      vm.deposit,
                      hintText: 'Advance Payment',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Installment Months', isRequired: true),
                    Row(
                      children: [
                        _monthButton(vm, 6, '6 Months', 25),
                        _monthButton(vm, 9, '9 Months', 32),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Monthly Installment', isRequired: true),
                    _buildTextField(
                      vm.monthlyInstallment,
                      hintText: 'Amount',
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Total Price', isRequired: true),
          _buildTextField(
            vm.totalPrice,
            hintText: 'Total Price',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Taken Date', isRequired: true),
                    _buildTextField(
                      vm.takenDate,
                      hintText: 'mm/dd/yyyy',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.grey,
                        ),
                        onPressed: () => vm.pickDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('End Date (Est.)', isRequired: true),
                    _buildTextField(
                      vm.endDate,
                      hintText: 'Auto Calculated',
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthButton(
    AddCustomerViewModel vm,
    int months,
    String text,
    double interest,
  ) {
    final isSelected = vm.selectedMonths == months;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.selectMonths(months, interest),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryTeal : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- Image Upload Section ---
  Widget _buildImageUpload(AddCustomerViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildSectionHeader('Item Image')),
          HorizontalDotedLine(),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: vm.pickImage,
            behavior: HitTestBehavior.opaque,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [10, 5],
                strokeWidth: 2,
                radius: Radius.circular(16),
                color: AppColors.primaryTeal,
                padding: EdgeInsets.all(8),
              ),
              child: Container(
                height: 160,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: vm.pickedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_rounded,
                            size: 40,
                            color: AppColors.darkGrey.withAlpha(120),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Click to upload item image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          vm.pickedImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(addCustomerVMProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Add New Installment Plan',
          style: TextStyle(
            color: AppColors.offWhite,
            fontSize: 20,
            fontWeight: .w700,
          ),
        ),
        backgroundColor: AppColors.slateGray,
      ),
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              _buildCustomerInformation(vm),
              const SizedBox(height: 24),
              _buildItemDetails(vm),
              const SizedBox(height: 24),
              _buildImageUpload(vm),
              const SizedBox(height: 32),
              SizedBox(
                height: 55,
                width: .infinity,
                child: AuthButton(
                  text: 'Save Plan',
                  onPressed: () {
                    Customer newCustomer = Customer(
                      name: vm.fullName.text,
                      fatherName: vm.fatherName.text,
                      cnic: vm.cnic.text,
                      phoneNumber: vm.mobile.text,
                      address: vm.address.text,
                      itemName: vm.itemName.text,
                      totalPrice: vm.totalPrice.text,
                      deposit: vm.deposit.text,
                      monthlyInstallment: vm.monthlyInstallment.text,
                      installmentMonths: vm.installmentMonths.text,
                      takenDate: vm.takenDate.text,
                      endDate: vm.endDate.text,
                      nextDueDate: _getNextDueDate(vm.takenDate.text),
                      imagePath: vm.pickedImage?.path,
                      totalPaid: vm.deposit.text,
                      remaining: (double.parse(vm.totalPrice.text) - double.parse(vm.deposit.text)).toStringAsFixed(0),
                      status: "Upcoming",
                      history: [],
                    );
                    ref.read(customerProvider.notifier).addCustomer(newCustomer);
                    // customerList.add(newCustomer);
                    Navigator.pop(context);
                  }, // backgroundColor: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  String _getNextDueDate(String takenDate) {
    DateTime d = DateTime.parse(takenDate); // must be yyyy-MM-dd
    DateTime next = DateTime(d.year, d.month + 1, d.day);
    return next.toIso8601String().split("T").first;
  }

}
