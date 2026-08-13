import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/key_model.dart';
import '../models/handover_model.dart';

class KeyRepository {
  // Singleton pattern for simple global state access
  static final KeyRepository _instance = KeyRepository._internal();
  factory KeyRepository() => _instance;
  KeyRepository._internal();

  late final SharedPreferences _prefs;

  final List<KeyModel> _keys = [
    KeyModel(
      id: 'key-1',
      keyName: 'Meeting Room',
      identifier: 'MR-01',
      status: KeyStatus.available,
    ),
    KeyModel(
      id: 'key-2',
      keyName: 'Server Room',
      identifier: 'SR-01',
      status: KeyStatus.available,
    ),
    KeyModel(
      id: 'key-3',
      keyName: 'Store Room',
      identifier: 'ST-01',
      status: KeyStatus.available,
    ),
    KeyModel(
      id: 'key-4',
      keyName: 'Main Gate',
      identifier: 'MG-01',
      status: KeyStatus.available,
    ),
  ];

  final List<HandoverModel> _handovers = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final String? keysString = _prefs.getString('keys');
    if (keysString != null) {
      final List<dynamic> decoded = jsonDecode(keysString);
      _keys.clear();
      _keys.addAll(decoded.map((k) => KeyModel.fromJson(k as Map<String, dynamic>)));
    } else {
      await _saveKeys();
    }

    final String? handoversString = _prefs.getString('handovers');
    if (handoversString != null) {
      final List<dynamic> decoded = jsonDecode(handoversString);
      _handovers.clear();
      _handovers.addAll(decoded.map((h) => HandoverModel.fromJson(h as Map<String, dynamic>)));
    }
  }

  Future<void> _saveKeys() async {
    final String encoded = jsonEncode(_keys.map((k) => k.toJson()).toList());
    await _prefs.setString('keys', encoded);
  }

  Future<void> _saveHandovers() async {
    final String encoded = jsonEncode(_handovers.map((h) => h.toJson()).toList());
    await _prefs.setString('handovers', encoded);
  }

  List<KeyModel> getKeys() {
    bool hasChanges = false;
    for (int i = 0; i < _keys.length; i++) {
      final key = _keys[i];
      if (key.status == KeyStatus.taken || key.status == KeyStatus.overdue) {
        final active = getActiveHandover(key.id);
        if (active != null) {
          final isOverdueNow = DateTime.now().isAfter(active.expectedReturnTime);
          if (isOverdueNow && key.status != KeyStatus.overdue) {
            _keys[i] = key.copyWith(status: KeyStatus.overdue);
            hasChanges = true;
          } else if (!isOverdueNow && key.status != KeyStatus.taken) {
            _keys[i] = key.copyWith(status: KeyStatus.taken);
            hasChanges = true;
          }
        }
      }
    }
    if (hasChanges) {
      _saveKeys();
    }
    return List.unmodifiable(_keys);
  }

  List<HandoverModel> getHandovers() {
    return List.unmodifiable(_handovers);
  }

  void updateKeyStatus(String keyId, KeyStatus newStatus) {
    final index = _keys.indexWhere((k) => k.id == keyId);
    if (index != -1) {
      _keys[index] = _keys[index].copyWith(status: newStatus);
      _saveKeys();
    }
  }

  void addHandover(HandoverModel handover) {
    _handovers.add(handover);
    _saveHandovers();
  }

  void updateHandover(HandoverModel updatedHandover) {
    final index = _handovers.indexWhere((h) => h.id == updatedHandover.id);
    if (index != -1) {
      _handovers[index] = updatedHandover;
      _saveHandovers();
    }
  }

  HandoverModel? getActiveHandover(String keyId) {
    try {
      return _handovers.firstWhere((h) => h.keyId == keyId && h.returnedTime == null);
    } catch (_) {
      return null;
    }
  }
}
