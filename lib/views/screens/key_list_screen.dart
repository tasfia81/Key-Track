import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../viewmodels/key_list_viewmodel.dart';
import '../widgets/key_card.dart';
import 'key_detail_screen.dart';
import 'handover_history_screen.dart';

class KeyListScreen extends StatefulWidget {
  const KeyListScreen({super.key});

  @override
  State<KeyListScreen> createState() => _KeyListScreenState();
}

class _KeyListScreenState extends State<KeyListScreen> with WidgetsBindingObserver {
  late final KeyListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = KeyListViewModel();
    _viewModel.loadKeys();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _viewModel.loadKeys();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Handover Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HandoverHistoryScreen(viewModel: _viewModel),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final keys = _viewModel.filteredKeys;

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
                  
                  // Search Bar
                  TextField(
                    onChanged: _viewModel.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search key, room ID, or holder...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Expanded(
                    child: keys.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _viewModel.searchQuery.isNotEmpty
                                      ? Icons.search_off_rounded
                                      : Icons.vpn_key_outlined,
                                  size: 64.w,
                                  color: theme.disabledColor.withValues(alpha: 0.5),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _viewModel.searchQuery.isNotEmpty
                                      ? 'No keys found'
                                      : 'No keys available',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
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
                                  ).then((_) {
                                    _viewModel.loadKeys();
                                  });
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
