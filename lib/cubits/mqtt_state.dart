part of 'mqtt_cubit.dart';

enum MqttStatus { initial, connected, disconnected, error }

class MqttState extends Equatable {
  final double? temperature;
  final MqttStatus status;

  const MqttState({
    required this.status,
    this.temperature,
  });

  const MqttState.initial() : this(status: MqttStatus.initial);

  MqttState copyWith({
    double? temperature,
    MqttStatus? status,
  }) {
    return MqttState(
      temperature: temperature ?? this.temperature,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [temperature, status];
}
