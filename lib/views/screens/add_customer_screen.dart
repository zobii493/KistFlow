import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kistflow/viewmodels/customer_viewmodel/view_customer_vm.dart';
import 'package:kistflow/widgets/horizontal_doted_line.dart';

import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/customer_viewmodel/add_customer_vm.dart';
import '../../viewmodels/customer_viewmodel/bottom_nav_vm.dart';
import '../../widgets/appbar.dart';
import '../../widgets/auth/button.dart';
import '../../widgets/custom_card/custom_image_upload.dart';
import '../../widgets/custom_card/custom_phone_field.dart';
import '../../widgets/custom_card/custom_text_field.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  bool _phoneError = false;
  bool _imageError = false;
  bool _isLoading = false;

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryTealOf(context),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.slateGrayOffWhiteOf(context),
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
        color: AppColors.offBlackOf(context),
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
          CustomTextField(
            controller: vm.fullName,
            hint: 'Enter customer name',
            requiredField: true,
          ),
          const SizedBox(height: 16),
          _buildLabel('Father Name'),
          CustomTextField(
            controller: vm.fatherName,
            hint: 'Enter father name',
            requiredField: true,
          ),
          const SizedBox(height: 16),
          _buildLabel("CNIC"),
          CustomTextField(
            controller: vm.cnic,
            hint: "xxxxx-xxxxxxx-x",
            keyboardType: TextInputType.number,
            requiredField: true,
            mask: "#####-#######-#", // CNIC format
          ),
          const SizedBox(height: 16),
          _buildLabel('Mobile Number'),
          CustomPhoneField(
            controller: vm.mobile,
            errorText: _phoneError ? "Enter a valid phone number" : null,
            onInputChanged: (PhoneNumber phoneNumber) {
              // NEW: Store complete phone number in ViewModel
              vm.updatePhoneNumber(phoneNumber);

              // Validate based on parsed number length
              setState(() {
                _phoneError = phoneNumber.parseNumber().length < 10;
              });
            },
            onChanged: (value) {
              setState(() {
                _phoneError = value.length < 10;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildLabel('Address'),
          CustomTextField(
            controller: vm.address,
            hint: 'Enter complete address',
            maxLines: 4,
            requiredField: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails(AddCustomerViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
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
          CustomTextField(controller:  vm.itemName, hint: 'e.g., Mobile', requiredField: true,),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Cash Price', isRequired: true),
                    CustomTextField(
                      controller: vm.price,
                      hint: 'Cash Price',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      requiredField: true,
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
                    CustomTextField(
                      controller: vm.deposit,
                      hint: 'Advance Payment',
                      keyboardType: TextInputType.number,
                      requiredField: true,
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
                    CustomTextField(
                      controller: vm.monthlyInstallment,
                      hint: 'Amount',
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      requiredField: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Total Price', isRequired: true),
          CustomTextField(
            controller: vm.totalPrice,
            hint: 'Total Price',
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
                    CustomTextField(
                     controller:  vm.takenDate,
                      hint: 'mm/dd/yyyy',
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
                    CustomTextField(
                    controller: vm.endDate,
                      hint: 'Auto Calculated',
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
            color: isSelected ? AppColors.primaryTealOf(context) : AppColors.offWhiteOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.slateGrayOffWhiteOf(context),
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
        color: AppColors.offBlackOf(context),
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
          CustomImageUpload(
            imageFile: vm.pickedImage,
            onTap: vm.pickImage,
            errorText: _imageError ? "Please upload an image" : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(addCustomerVMProvider);
    return Scaffold(
      appBar: Appbar(text: 'Add New Installment Plan',),
      backgroundColor: AppColors.offWhiteOf(context),
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
                  isLoading: _isLoading, // bind loading state
                    onPressed: () async {
                      setState(() {
                        _phoneError = vm.mobile.text.length != 10;
                        _imageError = vm.pickedImage == null;
                      });
                      if (_phoneError || _imageError) return;

                      setState(() => _isLoading = true);

                      try {
                        await vm.saveCustomer();

                        if (!mounted) return;

                        // CLEAR ALL FIELDS
                        vm.clearAllFields();

                        // SHOW SNACKBAR
                        UIHelper.showSnackBar(
                          context,
                          "Customer added successfully!",
                          isError: false,
                        );
                        // NAVIGATE BACK TO MAIN SCREEN AND SELECT VIEW CUSTOMER TAB
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // This will pop back to CustomNavBarScreen (root)

                        // Set navigation index to ViewCustomerScreen (index 1)
                        ref.read(navIndexProvider.notifier).state = 1;

                        // Refresh customer list to show new customer
                        ref.read(customerProvider.notifier).listenCustomers();
                      } catch (e) {
                        UIHelper.showSnackBar(
                          context,
                          "Failed to add customer: $e",
                          isError: true,
                        );
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}