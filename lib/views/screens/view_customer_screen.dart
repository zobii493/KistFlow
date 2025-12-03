import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../data/customer_data.dart';
import '../../models/customer.dart';
import '../../viewmodels/customer_viewmodel/customer_detail_vm.dart';
import '../../viewmodels/customer_viewmodel/view_customer_vm.dart';
import '../../widgets/custom_card/custom_card_screen.dart';
import 'customer_details_screen.dart';

class ViewCustomerScreen extends ConsumerStatefulWidget {
  const ViewCustomerScreen({super.key});

  @override
  ConsumerState<ViewCustomerScreen> createState() =>
      _ViewCustomerScreenState();
}

class _ViewCustomerScreenState extends ConsumerState<ViewCustomerScreen> {
  int _selectedTabIndex = 0;
  String _searchQuery = "";
  bool _newestFirst = true;

  final List<String> _tabs = [
    'All',
    'Paid',
    'Unpaid',
    'Overdue',
    'Upcoming',
    'Completed'
  ];

  late List<Customer> _customers;

  @override
  void initState() {
    super.initState();
    _customers = customerList;
  }

  List<Customer> get filteredCustomers {
    final customers = ref.watch(customerProvider);

    // 1. Search apply
    List<Customer> result =
    ref.read(customerProvider.notifier).search(_searchQuery);

    //  2. Tabs filter
    if (_selectedTabIndex != 0) {
      result = result.where((c) => c.status == _tabs[_selectedTabIndex]).toList();
    }

    //  3. Sort newest/oldest
    result.sort((a, b) {
      final dateA = DateTime.tryParse(a.takenDate) ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.takenDate) ?? DateTime(2000);

      return _newestFirst
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.slateGray,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.slateGray,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search customer...',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      if (value == "Newest") {
                        _newestFirst = true;
                      } else if (value == "Oldest") {
                        _newestFirst = false;
                      }
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "Newest",
                      child: Text("Newest"),
                    ),
                    const PopupMenuItem(
                      value: "Oldest",
                      child: Text("Oldest"),
                    ),
                  ],
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.filter_list, color: AppColors.slateGray),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedTabIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryTeal : AppColors.offWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        toolbarHeight: 130,
      ),
      body: filteredCustomers.isEmpty
          ? Center(
        child: Text(
          'No customers found',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.darkGrey,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCustomers.length,
        itemBuilder: (context, index) {
          return CustomerCard(
            customer: filteredCustomers[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDetailScreen(
                    customer: filteredCustomers[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}