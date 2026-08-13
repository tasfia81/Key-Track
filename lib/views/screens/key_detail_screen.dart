import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/key_model.dart';
import '../../viewmodels/key_list_viewmodel.dart';
import '../widgets/status_badge.dart';
import 'take_key_screen.dart';

class KeyDetailScreen extends StatelessWidget {
  final String keyId;
  final KeyListViewModel viewModel;

  const KeyDetailScreen({
    super.key,
    required this.keyId,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Details'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, child) {
            final keyModel = viewModel.getKeyById(keyId);
            if (keyModel == null) {
              return const Center(child: Text('Key not found'));
            }

            final activeHandover = viewModel.getActiveHandover(keyId);

            return Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Primary Details Card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                keyModel.keyName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 22.sp,
                                ),
                              ),
                              StatusBadge(status: keyModel.status),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Identifier: ${keyModel.identifier}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Handover Info Card (Shown if key is taken or overdue)
                  if ((keyModel.status == KeyStatus.taken || keyModel.status == KeyStatus.overdue) && activeHandover != null) ...[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Handover Details',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              icon: Icons.person_outline_rounded,
                              label: 'Holder',
                              value: activeHandover.personName,
                            ),
                            SizedBox(height: 16.h),
                            _buildInfoRow(
                              context,
                              icon: Icons.access_time_rounded,
                              label: 'Handover Time',
                              value: _formatDateTime(activeHandover.takenTime),
                            ),
                            SizedBox(height: 16.h),
                            _buildInfoRow(
                              context,
                              icon: Icons.date_range_rounded,
                              label: 'Expected Return',
                              value: _formatDateTime(activeHandover.expectedReturnTime),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Bottom Action Button
                  if (keyModel.status == KeyStatus.available) ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondaryBackground,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TakeKeyScreen(
                              keyId: keyId,
                              viewModel: viewModel,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Take Key',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else if (keyModel.status == KeyStatus.taken || keyModel.status == KeyStatus.overdue) ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusOverdueBg,
                        foregroundColor: AppColors.statusOverdueText,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(
                            color: AppColors.statusOverdueText,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        viewModel.returnKey(keyId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${keyModel.keyName} has been returned'),
                          ),
                        );
                      },
                      child: Text(
                        'Return Key',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 20.w, color: theme.primaryColor),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
