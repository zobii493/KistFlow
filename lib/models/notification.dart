import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String customerId;
  final String title;
  final String message;
  final DateTime date;
  final bool read;
  final Map<String, dynamic> paymentDetails;

  NotificationModel({
    required this.id,
    required this.customerId,
    required this.title,
    required this.message,
    required this.date,
    required this.read,
    required this.paymentDetails,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      customerId: data['customerId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      read: data['read'] ?? false,
      paymentDetails: Map<String, dynamic>.from(data['paymentDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'title': title,
      'message': message,
      'date': date,
      'read': read,
      'paymentDetails': paymentDetails,
    };
  }
}
