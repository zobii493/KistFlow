import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../services/cloudinary_service.dart';

final addCustomerVMProvider =
    ChangeNotifierProvider.autoDispose<AddCustomerViewModel>((ref) {
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

  // NEW: Store complete phone number with country code
  String? fullPhoneNumber; // Will store like "+923359612345"

  // NEW: Method to update full phone number
  void updatePhoneNumber(PhoneNumber phoneNumber) {
    fullPhoneNumber = phoneNumber.phoneNumber; // e.g., "+923359612345"
    notifyListeners();
  }

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


  String _getInitialStatus() {
    double paid = double.parse(deposit.text);
    double total = double.parse(totalPrice.text);

    DateTime today = DateTime.now();
    DateTime nextDue = DateTime.parse(_getNextDueDate(takenDate.text));

    // If already fully paid (just in case)
    if (paid >= total) return "Completed";

    // If taken date is in future → no cycle started yet
    DateTime taken = DateTime.parse(takenDate.text);
    if (today.isBefore(taken)) {
      return "Upcoming";
    }

    // If today is before first due → Upcoming
    if (today.isBefore(nextDue)) {
      return "Upcoming";
    }

    // Month started but not paid → Unpaid first
    if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 1 &&
        today.day <= 5) {
      return "Unpaid";
    }

    // After 6 of month → Overdue
    return "Overdue";
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<void> saveCustomer() async {
    if (pickedImage == null) return;

    // 1: Upload image to Cloudinary
    final imageUrl = await _cloudinaryService.uploadImage(pickedImage!);

    // 2: Prepare Firestore data
    final data = {
      "fullName": fullName.text,
      "fatherName": fatherName.text,
      "cnic": cnic.text,
      "mobile": fullPhoneNumber ?? mobile.text,
      "address": address.text,
      "item": {
        "name": itemName.text,
        "price": double.parse(price.text),
        "deposit": double.parse(deposit.text),
        "totalPrice": double.parse(totalPrice.text),
        "monthlyInstallment": double.parse(monthlyInstallment.text),
        "installmentMonths": int.parse(installmentMonths.text),
        "takenDate": takenDate.text,
        "endDate": endDate.text,
        "imageUrl": imageUrl,
      },
      "status": _getInitialStatus(),
      //todo: status will change if payment is done then paid and if another month comes again and payment is not done then change to unpaid/overdue
      "totalPaid": double.parse(deposit.text),
      "remaining": double.parse(totalPrice.text) - double.parse(deposit.text),
      "nextDueDate": _getNextDueDate(takenDate.text),
      "history": [],
      "createdAt": FieldValue.serverTimestamp(),
    };
    // 3: Save to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final userId = user.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .add(data);
  }

  String _getNextDueDate(String takenDate) {
    DateTime d = DateTime.parse(takenDate); // must be yyyy-MM-dd
    DateTime next = DateTime(d.year, d.month + 1, d.day);
    return next.toIso8601String().split("T").first;
  }

  void selectMonthsFromDropdown(int months) {
    selectedMonths = months;

    // Interest mapping
    if (months == 6) {
      interestPercent = 25;
    } else if (months == 9) {
      interestPercent = 32;
    } else if (months == 12) {
      interestPercent = 36; // 1 year = 36%
    }

    installmentMonths.text = months.toString();
    notifyListeners();
    _updateInstallmentCalculation();
  }


  void clearAllFields() {
    fullName.clear();
    fatherName.clear();
    cnic.clear();
    mobile.clear();
    address.clear();

    itemName.clear();
    price.clear();
    deposit.clear();
    totalPrice.clear();
    monthlyInstallment.clear();
    installmentMonths.clear();
    takenDate.clear();
    endDate.clear();

    pickedImage = null;
    selectedMonths = null;
    interestPercent = 0;

    notifyListeners();
  }

  @override
  void dispose() {
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
