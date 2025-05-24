import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  late final MqttServerClient client;

  MqttCubit() : super(const MqttState.initial()) {
    _initClient();
    _connect();
  }

  void _initClient() {
    client = MqttServerClient.withPort(
      'test.mosquitto.org',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );

    client
      ..setProtocolV311()
      ..logging(on: true)
      ..keepAlivePeriod = 20
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected;
  }

  Future<void> _connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    await client.connect();
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _setupSubscriptions();
    } else {
      _onError();
    }
  }

  void _setupSubscriptions() {
    client.subscribe('sensor/temperature/sasha2025', MqttQos.atMostOnce);
    client.updates?.listen(_handleIncomingMessage);
  }

  void _handleIncomingMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    final recMess = messages[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );

    final temperature = _parseTemperature(payload);
    if (temperature != null) {
      emit(state.copyWith(temperature: temperature));
    }
  }

  double? _parseTemperature(String payload) {
    final cleaned = payload.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned);
  }

  void _onConnected() => emit(state.copyWith(status: MqttStatus.connected));

  void _onDisconnected() =>
      emit(state.copyWith(status: MqttStatus.disconnected));

  void _onError() {
    client.disconnect();
    emit(state.copyWith(status: MqttStatus.error));
  }

  @override
  Future<void> close() {
    client.disconnect();
    return super.close();
  }
}
