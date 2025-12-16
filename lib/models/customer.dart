class Customer {
  final String id;
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
  final DateTime createdAt;

  Customer({
    required this.id,
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
    required this.createdAt,
  });

  /// Factory method to create Customer from Firestore document
  factory Customer.fromFirestore(Map<String, dynamic> data, String id) {
    return Customer(
      id: id,
      name: data['fullName'] ?? '',
      fatherName: data['fatherName'] ?? '',
      cnic: data['cnic'] ?? '',
      phoneNumber: data['mobile'] ?? '',
      address: data['address'] ?? '',
      itemName: data['item']?['name'] ?? '',
      totalPrice: (data['item']?['totalPrice'] ?? 0).toString(),
      deposit: (data['item']?['deposit'] ?? 0).toString(),
      monthlyInstallment: (data['item']?['monthlyInstallment'] ?? 0).toString(),
      installmentMonths: (data['item']?['installmentMonths'] ?? 0).toString(),
      totalPaid: (data['totalPaid'] ?? 0).toString(),
      remaining: (data['remaining'] ?? 0).toString(),
      takenDate: data['item']?['takenDate'] ?? '',
      endDate: data['item']?['endDate'] ?? '',
      nextDueDate: data['nextDueDate'] ?? '',
      status: data['status'] ?? 'Unpaid',
      imagePath: data['item']?['imageUrl'],
      history: List<Map<String, dynamic>>.from(data['history'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  /// Convert Customer to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': name,
      'fatherName': fatherName,
      'cnic': cnic,
      'mobile': phoneNumber,
      'address': address,
      'item': {
        'name': itemName,
        'totalPrice': double.tryParse(totalPrice) ?? 0,
        'deposit': double.tryParse(deposit) ?? 0,
        'monthlyInstallment': double.tryParse(monthlyInstallment) ?? 0,
        'installmentMonths': int.tryParse(installmentMonths) ?? 0,
        'takenDate': takenDate,
        'endDate': endDate,
        'imageUrl': imagePath,
      },
      'totalPaid': double.tryParse(totalPaid) ?? 0,
      'remaining': double.tryParse(remaining) ?? 0,
      'nextDueDate': nextDueDate,
      'status': status,
      'history': history,
      'createdAt': createdAt,
    };
  }

  /// Create a copy of Customer with updated fields
  Customer copyWith({
    String? id,
    String? name,
    String? fatherName,
    String? cnic,
    String? phoneNumber,
    String? address,
    String? itemName,
    String? totalPrice,
    String? deposit,
    String? monthlyInstallment,
    String? installmentMonths,
    String? totalPaid,
    String? remaining,
    String? status,
    String? takenDate,
    String? endDate,
    String? nextDueDate,
    String? imagePath,
    List<Map<String, dynamic>>? history,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      cnic: cnic ?? this.cnic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      itemName: itemName ?? this.itemName,
      totalPrice: totalPrice ?? this.totalPrice,
      deposit: deposit ?? this.deposit,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
      installmentMonths: installmentMonths ?? this.installmentMonths,
      totalPaid: totalPaid ?? this.totalPaid,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
      takenDate: takenDate ?? this.takenDate,
      endDate: endDate ?? this.endDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      imagePath: imagePath ?? this.imagePath,
      history: history ?? this.history,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}