import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer.dart';

class CustomerNotifier extends StateNotifier<List<Customer>> {
  CustomerNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription; // Stream subscription store

  // LISTEN TO REAL-TIME UPDATES
  void listenCustomers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Cancel previous subscription if exists
    _subscription?.cancel();

    // Start listening to real-time updates
    _subscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .orderBy('createdAt', descending: true) // Newest first
        .snapshots()
        .listen((snapshot) {
      // Update state whenever data changes
      state = snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime createdAt;
        if (data['createdAt'] != null) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else {
          createdAt = DateTime.now();
        }

        return Customer(
          id: doc.id,
          name: data['fullName'] ?? '',
          fatherName: data['fatherName'] ?? '',
          cnic: data['cnic'] ?? '',
          phoneNumber: data['mobile'] ?? '',
          address: data['address'] ?? '',
          itemName: data['item']['name'] ?? '',
          totalPrice: data['item']['totalPrice'].toString(),
          deposit: data['item']['deposit'].toString(),
          monthlyInstallment: data['item']['monthlyInstallment'].toString(),
          installmentMonths: data['item']['installmentMonths'].toString(),
          totalPaid: data['totalPaid'].toString(),
          remaining: data['remaining'].toString(),
          takenDate: data['item']['takenDate'] ?? '',
          endDate: data['item']['endDate'] ?? '',
          nextDueDate: data['nextDueDate'] ?? '',
          status: data['status'] ?? 'Upcoming',
          imagePath: data['item']['imageUrl'] ?? '',
          history: List<Map<String, dynamic>>.from(data['history'] ?? []),
          createdAt: createdAt,
        );
      }).toList();
    }, onError: (error) {
      print("Error listening to customers: $error");
    });
  }

  Future<void> deleteCustomer(String customerId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('customers')
          .doc(customerId)
          .delete();
    } catch (e) {
      print('Delete error: $e');
      rethrow;
    }
  }


  // ============================
  // STOP LISTENING (Important for cleanup)
  // ============================
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  // ============================
  // SEARCH FUNCTION
  // ============================
  List<Customer> search(String query) {
    if (query.isEmpty) return state;

    return state.where((c) {
      final q = query.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.phoneNumber.toLowerCase().contains(q) ||
          c.itemName.toLowerCase().contains(q);
    }).toList();
  }

  // ============================
  // SORTING by createdAt
  // ============================
  List<Customer> sortByCreatedDate(List<Customer> customers, bool newestFirst) {
    List<Customer> sorted = [...customers];

    sorted.sort((a, b) {
      return newestFirst
          ? b.createdAt.compareTo(a.createdAt) // Newest first
          : a.createdAt.compareTo(b.createdAt); // Oldest first
    });

    return sorted;
  }

  void addCustomer(Customer customer) {
    state = [customer, ...state];
  }

  void removeCustomer(String customerId) {
    state = state.where((c) => c.id != customerId).toList();
  }

  void updateCustomer(Customer customer) {
    state = [
      for (final c in state)
        if (c.id == customer.id) customer else c
    ];
  }

  @override
  void dispose() {
    stopListening(); // Clean up stream when provider is disposed
    super.dispose();
  }
}

// Provider
final customerProvider =
StateNotifierProvider<CustomerNotifier, List<Customer>>((ref) {
  final notifier = CustomerNotifier();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    notifier.stopListening();
  });

  return notifier;
});