// lib/views/report/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/views/screens/report/widgets/stats_cards.dart';

import '../../../core/app_colors.dart';
import '../../../models/report.dart';
import '../../../viewmodels/report_vm.dart';
import '../../../widgets/appbar.dart';
import 'components/customer_growth_chart.dart';
import 'components/product_categories_chart.dart';
import 'components/revenue_trend_chart.dart';
import 'components/top_performing_items.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportVMProvider);
    final viewModel = ref.read(reportVMProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Report & Analytics'),
      body: reportState.when(
        data: (state) => _buildContent(context, state, viewModel),
        loading: () => _buildLoading(context),
        error: (error, stack) => _buildError(context, error, ref),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      ReportState state,
      ReportViewModel viewModel,
      ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stats Cards (2x2 Grid)
            StatsCards(
              totalRevenue: state.totalRevenue,
              expected: state.expected,
              collectionRate: state.collectionRate,
              pending: state.pending,
            ),
            const SizedBox(height: 24),

            // Revenue Trend Chart
            RevenueTrendChart(
              data: state.revenueData,
              selectedPeriod: viewModel.selectedPeriod,
              onPeriodChanged: viewModel.updatePeriod,
            ),
            const SizedBox(height: 24),

            // Customer Growth Chart
            CustomerGrowthChart(data: state.customerGrowthData),
            const SizedBox(height: 24),

            // Product Categories Chart (if data exists)
            if (state.categoryData.isNotEmpty) ...[
              ProductCategoriesChart(categories: state.categoryData),
              const SizedBox(height: 24),
            ],

            // Top Performing Items (if data exists)
            if (state.topItems.isNotEmpty) ...[
              TopPerformingItems(items: state.topItems),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryTealOf(context),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.pinkOf(context),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.slateGrayOf(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkGreyOf(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(reportVMProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTealOf(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}