import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/key_model.dart';

class StatusBadge extends StatelessWidget {
  final KeyStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color text;
    String label;

    switch (status) {
      case KeyStatus.available:
        bg = isDark ? AppColors.statusAvailableBgDark : AppColors.statusAvailableBg;
        text = isDark ? AppColors.statusAvailableTextDark : AppColors.statusAvailableText;
        label = 'Available';
        break;
      case KeyStatus.taken:
        bg = isDark ? AppColors.statusTakenBgDark : AppColors.statusTakenBg;
        text = isDark ? AppColors.statusTakenTextDark : AppColors.statusTakenText;
        label = 'Taken';
        break;
      case KeyStatus.overdue:
        bg = isDark ? AppColors.statusOverdueBgDark : AppColors.statusOverdueBg;
        text = isDark ? AppColors.statusOverdueTextDark : AppColors.statusOverdueText;
        label = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
