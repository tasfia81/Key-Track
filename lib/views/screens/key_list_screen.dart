import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../viewmodels/key_list_viewmodel.dart';
import '../widgets/key_card.dart';
import 'key_detail_screen.dart';

class KeyListScreen extends StatefulWidget {
  const KeyListScreen({super.key});

  @override
  State<KeyListScreen> createState() => _KeyListScreenState();
}

class _KeyListScreenState extends State<KeyListScreen> {
  late final KeyListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = KeyListViewModel();
    _viewModel.loadKeys();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Handover Tracker'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final keys = _viewModel.keys;

            if (keys.isEmpty) {
              return Center(
                child: Text(
                  'No keys available',
                  style: theme.textTheme.titleMedium,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track and manage key handovers',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final item = keys[index];
                        return KeyCard(
                          keyModel: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KeyDetailScreen(
                                  keyId: item.id,
                                  viewModel: _viewModel,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
