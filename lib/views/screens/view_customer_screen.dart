import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/customer_data.dart';
import '../../models/customer.dart';
import '../../widgets/custom_card/custom_card_screen.dart';
import 'customer_details_screen.dart';

class ViewCustomerScreen extends StatefulWidget {
  const ViewCustomerScreen({super.key});

  @override
  State<ViewCustomerScreen> createState() => _ViewCustomerScreenState();
}

class _ViewCustomerScreenState extends State<ViewCustomerScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'All',
    'Paid',
    'Unpaid',
    'Overdue',
    'Upcoming',
  ];

  late List<Customer> _customers;

  @override
  void initState() {
    super.initState();
    _customers = customerList;
  }

  List<Customer> get filteredCustomers {
    if (_selectedTabIndex == 0) return _customers;
    return _customers.where((c) => c.status == _tabs[_selectedTabIndex]).toList();
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
                      children: const [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.slateGray,
                            decoration: InputDecoration(
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
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.slateGray),
                    onPressed: () {},
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
                        color: isSelected ? AppColors.primaryTeal : Colors.grey.shade300,
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