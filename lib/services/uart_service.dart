import 'dart:convert';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class UartService {
  UsbPort? _port;

  Future<bool> connect() async {
    final List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      return false;
    }

    final targetDevice = devices.first;
    _port = await targetDevice.create();
    if (!await _port!.open()) return false;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    return true;
  }

  Future<void> sendJson(Map<String, dynamic> data) async {
    if (_port == null) return;
    final jsonData = jsonEncode(data);
    final message = utf8.encode('$jsonData\n');
    await _port!.write(Uint8List.fromList(message));
  }

  Future<String?> readResponse() async {
    if (_port == null) return null;

    final buffer = StringBuffer();
    await for (final data in _port!.inputStream!) {
      buffer.write(utf8.decode(data));
      if (buffer.toString().contains('\n')) break;
    }

    final response = buffer.toString().trim();
    return response;
  }

  void disconnect() {
    _port?.close();
    _port = null;
  }
}
