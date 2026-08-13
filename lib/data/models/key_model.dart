enum KeyStatus {
  available,
  taken,
  overdue;

  String get value {
    switch (this) {
      case KeyStatus.available:
        return 'available';
      case KeyStatus.taken:
        return 'taken';
      case KeyStatus.overdue:
        return 'overdue';
    }
  }

  static KeyStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'taken':
        return KeyStatus.taken;
      case 'overdue':
        return KeyStatus.overdue;
      case 'available':
      default:
        return KeyStatus.available;
    }
  }
}

class KeyModel {
  final String id;
  final String keyName;
  final String identifier;
  final KeyStatus status;

  KeyModel({
    required this.id,
    required this.keyName,
    required this.identifier,
    required this.status,
  });

  KeyModel copyWith({
    String? id,
    String? keyName,
    String? identifier,
    KeyStatus? status,
  }) {
    return KeyModel(
      id: id ?? this.id,
      keyName: keyName ?? this.keyName,
      identifier: identifier ?? this.identifier,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyName': keyName,
      'identifier': identifier,
      'status': status.value,
    };
  }

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      id: json['id'] as String,
      keyName: json['keyName'] as String,
      identifier: json['identifier'] as String,
      status: KeyStatus.fromString(json['status'] as String),
    );
  }
}
