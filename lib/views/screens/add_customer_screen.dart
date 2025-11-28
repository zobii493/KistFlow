import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kistflow/widgets/auth/auth_button.dart';

import '../../core/app_colors.dart';
import '../../data/customer_data.dart';
import '../../models/customer.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // --- Customer Controllers ---
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // --- Item Controllers ---
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _monthlyInstallmentController =
      TextEditingController();
  final TextEditingController _installmentMonthsController =
      TextEditingController();
  final TextEditingController _totalpriceController = TextEditingController();
  final TextEditingController _takenDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Item Details logic
    _installmentMonthsController.addListener(_calculateEndDate);
    _takenDateController.addListener(_calculateEndDate);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    // Dispose Customer Controllers
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    // Dispose Item Controllers
    _itemNameController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _totalpriceController.dispose();
    _monthlyInstallmentController.dispose();
    _installmentMonthsController.dispose();
    _takenDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // --- Item Logic ---

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _takenDateController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _calculateEndDate() {
    if (_takenDateController.text.isNotEmpty &&
        _installmentMonthsController.text.isNotEmpty) {
      try {
        List<String> dateParts = _takenDateController.text.split('/');
        int month = int.parse(dateParts[0]);
        int day = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        DateTime takenDate = DateTime(year, month, day);
        int installmentMonths = int.parse(_installmentMonthsController.text);

        DateTime endDate = DateTime(
          takenDate.year,
          takenDate.month + installmentMonths,
          takenDate.day,
        );

        _endDateController.text =
            "${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}/${endDate.year}";
      } catch (e) {
        _endDateController.text = "Error"; // Handle format error
      }
    } else {
      _endDateController.text = "Auto Calculated";
    }
  }

  // --- Reusable TextField Widget ---

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
  }

  // --- Widget Builders ---

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

  // --- Customer Information Section ---

  Widget _buildCustomerInformation() {
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
          SizedBox(
            height: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Center dashed line
                Center(
                  child: Text(
                    '----------------------',
                    style: TextStyle(
                      letterSpacing: 8,
                      fontSize: 24,
                      color: AppColors.darkGrey.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                // Left circle (half outside)
                Positioned(
                  left: -27,
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
                  right: -27,
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

          // Full Name
          _buildLabel('Full Name'),
          _buildTextField(
            _fullNameController,
            hintText: 'Enter customer name',
            required: true,
          ),
          const SizedBox(height: 16),

          // Father Name
          _buildLabel('Father Name'),
          _buildTextField(
            _fatherNameController,
            hintText: 'Enter father name',
            required: true,
          ),
          const SizedBox(height: 16),
          // CNIC
          _buildLabel('CNIC'),
          _buildTextField(
            _cnicController,
            hintText: 'xxxxx-xxxxxxx-x',
            required: true,
          ),
          const SizedBox(height: 16),
          // Mobile Number
          _buildLabel('Mobile Number'),
          _buildTextField(
            _mobileNumberController,
            hintText: '03XX-XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
          ),
          const SizedBox(height: 16),

          // Address
          _buildLabel('Address'),
          _buildTextField(
            _addressController,
            hintText: 'Enter complete address',
            maxLines: 4,
            required: true,
          ),
        ],
      ),
    );
  }

  // --- Item Details Section ---

  Widget _buildItemDetails() {
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
          SizedBox(
            height: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Center dashed line
                Center(
                  child: Text(
                    '----------------------',
                    style: TextStyle(
                      letterSpacing: 8,
                      fontSize: 24,
                      color: AppColors.darkGrey.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                // Left circle (half outside)
                Positioned(
                  left: -27,
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
                  right: -27,
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
          const SizedBox(height: 10),

          // Item Name
          _buildLabel('Item Name', isRequired: true),
          _buildTextField(_itemNameController, hintText: 'e.g., Mobile'),
          const SizedBox(height: 16),

          // Price & Deposit Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Cash Price', isRequired: true),
                    _buildTextField(
                      _priceController,
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
                      _depositController,
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

          // Monthly Installment & Installment Months Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Installment Months', isRequired: true),
                    _buildTextField(
                      _installmentMonthsController,
                      hintText: 'Total Months',
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
                    _buildLabel('Monthly Installment', isRequired: true),
                    _buildTextField(
                      _monthlyInstallmentController,
                      hintText: 'Amount',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Total Price', isRequired: true),
          _buildTextField(
            _totalpriceController,
            hintText: 'Total Price',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          // Taken Date & End Date Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Taken Date', isRequired: true),
                    _buildTextField(
                      _takenDateController,
                      hintText: 'mm/dd/yyyy',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: AppColors.darkGrey,
                        ),
                        onPressed: () => _selectDate(context),
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
                      _endDateController,
                      hintText: 'Auto Calculated',
                      readOnly: true,
                      fillColor: AppColors.lightGrey.withOpacity(0.5),
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

  //---Image Upload Section---
  Widget _buildImageUpload() {
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
          SizedBox(
            height: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Text(
                    '----------------------',
                    style: TextStyle(
                      letterSpacing: 8,
                      fontSize: 24,
                      color: AppColors.darkGrey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Positioned(
                  left: -27,
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
                Positioned(
                  right: -27,
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

          //IMAGE PICKER UI
          GestureDetector(
            onTap: _pickImage,
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
                child: _pickedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_rounded,
                            size: 40,
                            color: AppColors.darkGrey.withValues(alpha: 0.5),
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
                          _pickedImage!,
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

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerInformation(),
              const SizedBox(height: 24),
              _buildItemDetails(),
              const SizedBox(height: 24),
              _buildImageUpload(),
              const SizedBox(height: 32),
              SizedBox(
                height: 55,
                width: .infinity,
                child: AuthButton(
                  text: 'Save Plan',
                  onPressed: () {
                    Customer newCustomer = Customer(
                      name: _fullNameController.text,
                      fatherName: _fatherNameController.text,
                      cnic: _cnicController.text,
                      phoneNumber: _mobileNumberController.text,
                      address: _addressController.text,
                      itemName: _itemNameController.text,
                      totalPrice: _priceController.text,
                      deposit: _depositController.text,
                      monthlyInstallment: _monthlyInstallmentController.text,
                      installmentMonths: _installmentMonthsController.text,
                      takenDate: _takenDateController.text,
                      endDate: _endDateController.text,
                      nextDueDate: "Not Set",
                      imagePath: _pickedImage?.path,
                      totalPaid: "0",
                      remaining: _priceController.text,
                      status: "Upcoming",
                      history: [],
                    );

                    customerList.add(newCustomer);

                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.primaryTeal,
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
