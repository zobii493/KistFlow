import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final addCustomerVMProvider = ChangeNotifierProvider.autoDispose<AddCustomerViewModel>((ref) {
  return AddCustomerViewModel();
});


class AddCustomerViewModel extends ChangeNotifier {
  // --- Controllers ---
  final fullName = TextEditingController();
  final fatherName = TextEditingController();
  final cnic = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();

  final itemName = TextEditingController();
  final price = TextEditingController();
  final deposit = TextEditingController();
  final totalPrice = TextEditingController();
  final monthlyInstallment = TextEditingController();
  final installmentMonths = TextEditingController();
  final takenDate = TextEditingController();
  final endDate = TextEditingController();

  File? pickedImage;
  final ImagePicker _picker = ImagePicker();

  int? selectedMonths;
  double interestPercent = 0;

  AddCustomerViewModel() {
    installmentMonths.addListener(_calculateEndDate);
    takenDate.addListener(_calculateEndDate);

    price.addListener(_updateInstallmentCalculation);
    deposit.addListener(_updateInstallmentCalculation);
  }

  // --- IMAGE PICKING ---
  Future<void> pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      pickedImage = File(img.path);
      notifyListeners();
    }
  }

  // --- DATE PICKER ---
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Correct & parseable date format
      takenDate.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      notifyListeners();
      _calculateEndDate();
    }
  }


  // --- END DATE CALCULATION ---
  void _calculateEndDate() {
    if (takenDate.text.isNotEmpty && installmentMonths.text.isNotEmpty) {
      try {
        DateTime start = DateTime.parse(takenDate.text);
        int months = int.parse(installmentMonths.text);

        DateTime end = DateTime(start.year, start.month + months, start.day);

        endDate.text =
        "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
      } catch (_) {
        endDate.text = "Error";
      }
    } else {
      endDate.text = "Auto Calculated";
    }

    notifyListeners();
  }


  // --- MONTH SELECT ---
  void selectMonths(int months, double interest) {
    selectedMonths = months;
    interestPercent = interest;
    installmentMonths.text = months.toString();
    notifyListeners();
    _updateInstallmentCalculation();
  }

  // --- INSTALLMENT CALCULATION ---
  void _updateInstallmentCalculation() {
    if (price.text.isEmpty || deposit.text.isEmpty || selectedMonths == null) {
      return;
    }

    final p = double.parse(price.text);
    final d = double.parse(deposit.text);
    final interestAmount = (p * interestPercent) / 100;
    final tPrice = p + interestAmount;
    final remaining = tPrice - d;
    final perMonth = remaining / selectedMonths!;

    totalPrice.text = tPrice.toStringAsFixed(0);
    monthlyInstallment.text = perMonth.toStringAsFixed(0);
    notifyListeners();

    _calculateEndDate();
  }

  @override
  void dispose() {
    // Dispose VM controllers if needed
    // final vm = ref.read(addCustomerVMProvider);
    fullName.dispose();
    fatherName.dispose();
    cnic.dispose();
    mobile.dispose();
    address.dispose();
    itemName.dispose();
    price.dispose();
    deposit.dispose();
    totalPrice.dispose();
    monthlyInstallment.dispose();
    installmentMonths.dispose();
    takenDate.dispose();
    endDate.dispose();
    super.dispose();
  }
}
