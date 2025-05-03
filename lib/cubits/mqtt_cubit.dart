import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  late final MqttServerClient client;

  MqttCubit() : super(const MqttState.initial()) {
    _connectAndListen();
  }

  Future<void> _connectAndListen() async {
    client = MqttServerClient.withPort(
      'test.mosquitto.org',
      'flutter_client_id_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );

    client.setProtocolV311();
    client.logging(on: true);
    client.keepAlivePeriod = 20;

    client.onDisconnected =
        () => emit(state.copyWith(status: MqttStatus.disconnected));
    client.onConnected =
        () => emit(state.copyWith(status: MqttStatus.connected));
    client.onSubscribed = (_) {};

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
      emit(state.copyWith(status: MqttStatus.error));
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      emit(state.copyWith(status: MqttStatus.connected));

      client.subscribe('sensor/temperature/sasha2025', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        final cleaned = payload.replaceAll(RegExp(r'[^0-9.\-]'), '');
        final parsedTemp = double.tryParse(cleaned);

        if (parsedTemp != null) {
          emit(state.copyWith(temperature: parsedTemp));
        }
      });
    } else {
      emit(state.copyWith(status: MqttStatus.error));
    }
  }
}
