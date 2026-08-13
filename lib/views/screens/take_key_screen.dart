import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/key_model.dart';
import '../../viewmodels/key_list_viewmodel.dart';

class TakeKeyScreen extends StatefulWidget {
  final String keyId;
  final KeyListViewModel viewModel;

  const TakeKeyScreen({
    super.key,
    required this.keyId,
    required this.viewModel,
  });

  @override
  State<TakeKeyScreen> createState() => _TakeKeyScreenState();
}

class _TakeKeyScreenState extends State<TakeKeyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  late final DateTime _handoverTime;
  DateTime? _expectedReturnTime;

  @override
  void initState() {
    super.initState();
    _handoverTime = DateTime.now();
    // Default expected return time: tomorrow at the same time
    _expectedReturnTime = _handoverTime.add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  Future<void> _selectExpectedReturnTime() async {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _expectedReturnTime ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_expectedReturnTime ?? now),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _expectedReturnTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submitForm(KeyModel keyModel) {
    if (!_formKey.currentState!.validate()) return;
    
    final returnTime = _expectedReturnTime;
    if (returnTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select expected return time')),
      );
      return;
    }

    if (returnTime.isBefore(_handoverTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return time must be after handover time')),
      );
      return;
    }

    widget.viewModel.takeKey(
      keyId: widget.keyId,
      personName: _nameController.text.trim(),
      expectedReturnTime: returnTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${keyModel.keyName} handed over to ${_nameController.text}')),
    );

    Navigator.pop(context); // Go back to details screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyModel = widget.viewModel.getKeyById(widget.keyId);

    if (keyModel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Key not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Key'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Read-only info container about the key
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.vpn_key_rounded, color: theme.primaryColor, size: 28.w),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            keyModel.keyName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Identifier: ${keyModel.identifier}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Name Input field
                Text(
                  'Person Name',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _nameController,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Enter name of the person taking the key',
                    hintStyle: theme.textTheme.bodyMedium,
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.statusOverdueText,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.statusOverdueText,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Handover Time (read-only)
                Text(
                  'Handover Time',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color?.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 20, color: AppColors.textSecondary),
                      SizedBox(width: 12.w),
                      Text(
                        _formatDateTime(_handoverTime),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Expected Return Time (selectable)
                Text(
                  'Expected Return Time',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: _selectExpectedReturnTime,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, size: 20.w, color: theme.primaryColor),
                            SizedBox(width: 12.w),
                            Text(
                              _expectedReturnTime == null
                                  ? 'Select Return Date & Time'
                                  : _formatDateTime(_expectedReturnTime!),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Confirm button
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
                  onPressed: () => _submitForm(keyModel),
                  child: Text(
                    'Confirm Handover',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
