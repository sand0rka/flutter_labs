import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/services/uart_service.dart';

part 'state.dart';

class MicrocontrollerCubit extends Cubit<MicrocontrollerState> {
  MicrocontrollerCubit() : super(MicrocontrollerState.initial());

  final _uartService = UartService();

  Future<void> fetchSerial() async {
    emit(state.copyWith(isLoading: true));

    final connected = await _uartService.connect();
    if (!connected) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to connect to microcontroller.',
          isLoading: false,
        ),
      );
      return;
    }

    await _uartService.sendJson({'action': 'read_serial'});
    final response = await _uartService.readResponse();
    _uartService.disconnect();

    final message = _extractMessageFromResponse(response);
    emit(
      state.copyWith(serialNumber: message ?? 'No response', isLoading: false),
    );
  }

  Future<void> updateSerial({
    required String serial,
    required String username,
    required String password,
  }) async {
    final connected = await _uartService.connect();
    if (!connected) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to connect to microcontroller.',
        ),
      );
      return;
    }

    await _uartService.sendJson({
      'username': username,
      'password': password,
      'serial_number': serial,
    });

    final response = await _uartService.readResponse();
    _uartService.disconnect();

    final message = _extractMessageFromResponse(response);
    emit(
      state.copyWith(
        serialNumber: serial,
        infoMessage: message ?? 'Serial number updated.',
      ),
    );
  }

  String? _extractMessageFromResponse(String? response) {
    if (response == null) return null;
    try {
      final jsonResponse = jsonDecode(response);
      return jsonResponse['message']?.toString();
    } catch (_) {
      return response;
    }
  }

  void clearMessages() {
    emit(state.copyWith());
  }
}
