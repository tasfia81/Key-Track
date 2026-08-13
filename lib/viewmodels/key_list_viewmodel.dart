import 'package:flutter/material.dart';
import '../data/models/key_model.dart';
import '../data/models/handover_model.dart';
import '../data/repositories/key_repository.dart';

class KeyListViewModel extends ChangeNotifier {
  final KeyRepository _repository = KeyRepository();

  List<KeyModel> _keys = [];
  List<KeyModel> get keys => _keys;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadKeys() {
    _isLoading = true;
    notifyListeners();

    _keys = _repository.getKeys();
    
    _isLoading = false;
    notifyListeners();
  }

  KeyModel? getKeyById(String keyId) {
    try {
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
