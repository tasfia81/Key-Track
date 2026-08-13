import 'package:flutter/material.dart';
import '../data/models/key_model.dart';
import '../data/models/handover_model.dart';
import '../data/repositories/key_repository.dart';

class KeyListViewModel extends ChangeNotifier {
  final KeyRepository _repository = KeyRepository();

  List<KeyModel> _keys = [];
  List<KeyModel> get keys => _keys;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadKeys() {
    _isLoading = true;
    notifyListeners();

    _keys = _repository.getKeys();
    
    _isLoading = false;
    notifyListeners();
  }

  List<KeyModel> get filteredKeys {
    if (_searchQuery.isEmpty) {
      return _keys;
    }
    final query = _searchQuery.toLowerCase();
    return _keys.where((key) {
      final matchesKeyName = key.keyName.toLowerCase().contains(query);
      final matchesIdentifier = key.identifier.toLowerCase().contains(query);
      
      bool matchesPerson = false;
      if (key.status == KeyStatus.taken || key.status == KeyStatus.overdue) {
        final active = getActiveHandover(key.id);
        if (active != null && active.personName.toLowerCase().contains(query)) {
          matchesPerson = true;
        }
      }
      return matchesKeyName || matchesIdentifier || matchesPerson;
    }).toList();
  }

  List<HandoverModel> get handovers {
    return _repository.getHandovers();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  KeyModel? getKeyById(String keyId) {
    try {
      // Force refreshing the status check when querying key by ID
      _keys = _repository.getKeys();
      return _keys.firstWhere((k) => k.id == keyId);
    } catch (_) {
      return null;
    }
  }

  HandoverModel? getActiveHandover(String keyId) {
    return _repository.getActiveHandover(keyId);
  }

  void takeKey({
    required String keyId,
    required String personName,
    required DateTime expectedReturnTime,
  }) {
    final key = getKeyById(keyId);
    if (key == null) return;

    final now = DateTime.now();
    final handover = HandoverModel(
      id: 'handover-${DateTime.now().millisecondsSinceEpoch}',
      keyId: keyId,
      keyName: key.keyName,
      identifier: key.identifier,
      personName: personName,
      takenTime: now,
      expectedReturnTime: expectedReturnTime,
      status: 'active',
    );

    _repository.addHandover(handover);
    _repository.updateKeyStatus(keyId, KeyStatus.taken);
    loadKeys();
  }

  void returnKey(String keyId) {
    final activeHandover = getActiveHandover(keyId);
    if (activeHandover == null) return;

    final updatedHandover = activeHandover.copyWith(
      returnedTime: DateTime.now(),
      status: 'returned',
    );

    _repository.updateHandover(updatedHandover);
    _repository.updateKeyStatus(keyId, KeyStatus.available);
    loadKeys();
  }
}
