import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer.dart';

class CustomerNotifier extends StateNotifier<List<Customer>> {
  CustomerNotifier() : super([]);

  void addCustomer(Customer customer) {
    state = [...state, customer];
  }

  void removeCustomer(Customer customer) {
    state = state.where((c) => c != customer).toList();
  }

  void updateCustomer(Customer customer) {
    state = [
      for (final c in state)
        if (c == customer) customer else c
    ];
  }

  // ============================
  // 🔍 SEARCH FUNCTION
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
  // 🔽 SORTING (NEWEST / OLDEST)
  // ============================
  List<Customer> sortByDate(bool newestFirst) {
    List<Customer> sorted = [...state];

    sorted.sort((a, b) {
      final dateA = DateTime.tryParse(a.takenDate) ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.takenDate) ?? DateTime(2000);

      return newestFirst
          ? dateB.compareTo(dateA) // Newest first
          : dateA.compareTo(dateB); // Oldest first
    });

    return sorted;
  }
}

DateTime addMonth(DateTime date) {
  int year = date.year;
  int month = date.month + 1;
  int day = date.day;

  if (month > 12) {
    year++;
    month -= 12;
  }

  // Safe date (Feb 30 etc)
  final lastDay = DateTime(year, month + 1, 0).day;
  if (day > lastDay) day = lastDay;

  return DateTime(year, month, day);
}


// Provider
final customerProvider =
StateNotifierProvider<CustomerNotifier, List<Customer>>((ref) {
  return CustomerNotifier();
});
