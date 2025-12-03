class Customer {
  final String name;
  final String fatherName;
  final String cnic;
  final String phoneNumber;
  final String address;
  final String itemName;
  final String totalPrice;
  final String deposit;
  final String monthlyInstallment;
  final String installmentMonths;

  String totalPaid;
  String remaining;
  String status;

  final String takenDate;
  final String endDate;
  String nextDueDate;

  final String? imagePath;
  List<Map<String, dynamic>> history;

  Customer({
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.phoneNumber,
    required this.address,
    required this.itemName,
    required this.totalPrice,
    required this.deposit,
    required this.monthlyInstallment,
    required this.installmentMonths,
    required this.totalPaid,
    required this.remaining,
    required this.takenDate,
    required this.endDate,
    required this.nextDueDate,
    required this.status,
    this.imagePath,
    required this.history,
  });
}
