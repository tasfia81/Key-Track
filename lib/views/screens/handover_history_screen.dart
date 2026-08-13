import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/handover_model.dart';
import '../../viewmodels/key_list_viewmodel.dart';

class HandoverHistoryScreen extends StatelessWidget {
  final KeyListViewModel viewModel;

  const HandoverHistoryScreen({
    super.key,
    required this.viewModel,
  });

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = viewModel.handovers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Handover History'),
      ),
      body: SafeArea(
        child: history.isEmpty
            ? Center(
                child: Text(
                  'No history records found',
                  style: theme.textTheme.titleMedium,
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final record = history[history.length - 1 - index]; // Show latest first
                  return _buildHistoryCard(context, record);
                },
              ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, HandoverModel record) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine status and style for the record
    String statusText;
    Color bg;
    Color text;

    if (record.returnedTime != null) {
      statusText = 'Returned';
      bg = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0); // Slate badge
      text = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF475569);
    } else {
      final isOverdue = DateTime.now().isAfter(record.expectedReturnTime);
      if (isOverdue) {
        statusText = 'Overdue';
        bg = isDark ? AppColors.statusOverdueBgDark : AppColors.statusOverdueBg;
        text = isDark ? AppColors.statusOverdueTextDark : AppColors.statusOverdueText;
      } else {
        statusText = 'Taken';
        bg = isDark ? AppColors.statusTakenBgDark : AppColors.statusTakenBg;
        text = isDark ? AppColors.statusTakenTextDark : AppColors.statusTakenText;
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Key info & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.keyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'ID: ${record.identifier}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: text,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Handover borrower details
            _buildDetailRow(
              context,
              icon: Icons.person_outline_rounded,
              label: 'Taken By',
              value: record.personName,
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              context,
              icon: Icons.access_time_rounded,
              label: 'Taken Time',
              value: _formatDateTime(record.takenTime),
            ),
            SizedBox(height: 8.h),
            if (record.returnedTime != null)
              _buildDetailRow(
                context,
                icon: Icons.assignment_turned_in_rounded,
                label: 'Returned Time',
                value: _formatDateTime(record.returnedTime!),
              )
            else
              _buildDetailRow(
                context,
                icon: Icons.date_range_rounded,
                label: 'Expected Return',
                value: _formatDateTime(record.expectedReturnTime),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16.w, color: theme.primaryColor.withValues(alpha: 0.8)),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
