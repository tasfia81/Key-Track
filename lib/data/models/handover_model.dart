class HandoverModel {
  final String id;
  final String keyId;
  final String keyName;
  final String identifier;
  final String personName;
  final DateTime takenTime;
  final DateTime expectedReturnTime;
  final DateTime? returnedTime;
  final String status; // active, returned, overdue

  HandoverModel({
    required this.id,
    required this.keyId,
    required this.keyName,
    required this.identifier,
    required this.personName,
    required this.takenTime,
    required this.expectedReturnTime,
    this.returnedTime,
    required this.status,
  });

  HandoverModel copyWith({
    String? id,
    String? keyId,
    String? keyName,
    String? identifier,
    String? personName,
    DateTime? takenTime,
    DateTime? expectedReturnTime,
    DateTime? returnedTime,
    String? status,
  }) {
    return HandoverModel(
      id: id ?? this.id,
      keyId: keyId ?? this.keyId,
      keyName: keyName ?? this.keyName,
      identifier: identifier ?? this.identifier,
      personName: personName ?? this.personName,
      takenTime: takenTime ?? this.takenTime,
      expectedReturnTime: expectedReturnTime ?? this.expectedReturnTime,
      returnedTime: returnedTime ?? this.returnedTime,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyId': keyId,
      'keyName': keyName,
      'identifier': identifier,
      'personName': personName,
      'takenTime': takenTime.toIso8601String(),
      'expectedReturnTime': expectedReturnTime.toIso8601String(),
      'returnedTime': returnedTime?.toIso8601String(),
      'status': status,
    };
  }

  factory HandoverModel.fromJson(Map<String, dynamic> json) {
    return HandoverModel(
      id: json['id'] as String,
      keyId: json['keyId'] as String,
      keyName: json['keyName'] as String,
      identifier: json['identifier'] as String,
      personName: json['personName'] as String,
      takenTime: DateTime.parse(json['takenTime'] as String),
      expectedReturnTime: DateTime.parse(json['expectedReturnTime'] as String),
      returnedTime: json['returnedTime'] != null
          ? DateTime.parse(json['returnedTime'] as String)
          : null,
      status: json['status'] as String,
    );
  }
}
