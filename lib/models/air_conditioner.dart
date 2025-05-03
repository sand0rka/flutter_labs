class AirConditioner {
  final String id;
  final String userId;
  final String location;
  final double temperature;
  final bool isOn;

  AirConditioner({
    required this.id,
    required this.userId,
    required this.location,
    required this.temperature,
    required this.isOn,
  });

  factory AirConditioner.fromJSON(Map<String, dynamic> json) {
    return AirConditioner(
      id: json['id'] as String,
      userId: json['userId'] as String,
      location: json['location'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      isOn: json['isOn'] as bool,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'userId': userId,
      'location': location,
      'temperature': temperature,
      'isOn': isOn,
    };
  }

  AirConditioner copyWith({
    String? id,
    String? userId,
    String? location,
    double? temperature,
    bool? isOn,
  }) {
    return AirConditioner(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      isOn: isOn ?? this.isOn,
    );
  }
}
