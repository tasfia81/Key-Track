import '../models/key_model.dart';
import '../models/handover_model.dart';

class KeyRepository {
  // Singleton pattern for simple global state access
  static final KeyRepository _instance = KeyRepository._internal();
  factory KeyRepository() => _instance;
  KeyRepository._internal();

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

  List<KeyModel> getKeys() {
    return List.unmodifiable(_keys);
  }

  List<HandoverModel> getHandovers() {
    return List.unmodifiable(_handovers);
  }

  void updateKeyStatus(String keyId, KeyStatus newStatus) {
    final index = _keys.indexWhere((k) => k.id == keyId);
    if (index != -1) {
      _keys[index] = _keys[index].copyWith(status: newStatus);
    }
  }

  void addHandover(HandoverModel handover) {
    _handovers.add(handover);
  }

  void updateHandover(HandoverModel updatedHandover) {
    final index = _handovers.indexWhere((h) => h.id == updatedHandover.id);
    if (index != -1) {
      _handovers[index] = updatedHandover;
    }
  }
}
