import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/key_model.dart';
import 'status_badge.dart';

class KeyCard extends StatelessWidget {
  final KeyModel keyModel;
  final VoidCallback onTap;

  const KeyCard({
    super.key,
    required this.keyModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Premium Key Icon Container
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.vpn_key_rounded,
                    color: theme.primaryColor,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),
                // Room and Identifier details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyModel.keyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        keyModel.identifier,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                StatusBadge(status: keyModel.status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
