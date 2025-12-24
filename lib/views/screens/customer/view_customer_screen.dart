import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../../../models/customer.dart';
import '../../../viewmodels/customer_viewmodel/view_customer_vm.dart';
import '../../../widgets/custom_widgets/custom_card_screen.dart';
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

  @override
  void initState() {
    super.initState();
    // Start listening immediately when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerProvider.notifier).listenCustomers();
    });
  }

  List<Customer> get filteredCustomers {
    final customers = ref.watch(customerProvider);

    // 1. Search apply
    List<Customer> result = ref.read(customerProvider.notifier).search(_searchQuery);

    // 2. Tabs filter
    if (_selectedTabIndex != 0) {
      result = result.where((c) => c.status == _tabs[_selectedTabIndex]).toList();
    }

    // 3. Sort by CREATED DATE (not taken date)
    result = ref.read(customerProvider.notifier)
        .sortByCreatedDate(result, _newestFirst);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.slateGrayOf(context).withValues(alpha: 0.8),
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
                      color: AppColors.offBlackOf(context),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.slateGrayOf(context),
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
                      color: AppColors.offBlackOf(context),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.filter_list, color: AppColors.darkGreyOf(context)),
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
                        color: isSelected ? AppColors.primaryTealOf(context) : AppColors.offBlackOf(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? AppColors.offWhite : AppColors.darkGreyOf(context),
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
            color: AppColors.darkGreyOf(context),
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,16,16,116),
        itemCount: filteredCustomers.length,
        itemBuilder: (context, index) {
          final customer = filteredCustomers[index];

          return Dismissible(
            key: ValueKey(customer.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Customer'),
                  content: Text(
                    'Are you sure you want to delete ${customer.name}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel', style: TextStyle(color: AppColors.darkGreyOf(context))),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkOf(context),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) async {
              await ref
                  .read(customerProvider.notifier)
                  .deleteCustomer(customer.id);
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: AppColors.pinkOf(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            child: CustomerCard(
              customer: customer,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CustomerDetailScreen(customerId: customer.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}