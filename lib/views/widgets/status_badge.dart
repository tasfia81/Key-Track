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
    Color bg;
    Color text;
    String label;

    switch (status) {
      case KeyStatus.available:
        bg = AppColors.statusAvailableBg;
        text = AppColors.statusAvailableText;
        label = 'Available';
        break;
      case KeyStatus.taken:
        bg = AppColors.statusTakenBg;
        text = AppColors.statusTakenText;
        label = 'Taken';
        break;
      case KeyStatus.overdue:
        bg = AppColors.statusOverdueBg;
        text = AppColors.statusOverdueText;
        label = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: text.withValues(alpha: 0.3),
          width: 1,
        ),
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
