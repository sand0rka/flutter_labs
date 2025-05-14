import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/services/uart_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  void _onQRScanned(BuildContext context, String rawValue) {
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(rawValue) as Map<String, dynamic>;
      final username = decoded['username']?.toString();
      final password = decoded['password']?.toString();

      if (username != null && password != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          _showSerialNumberDialog(context, username, password);
        });
        return;
      }

      _showMessage(context, 'QR code does not contain valid credentials.');
    } catch (_) {
      _showMessage(context, 'Failed to parse QR code.');
    }
  }

  void _showSerialNumberDialog(
      BuildContext context, String username, String password,) {
    final serialController = TextEditingController();
    final uartService = UartService();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            const Text('Enter New Serial Number', style: AppTextStyles.title),
        content: TextField(
          controller: serialController,
          style: AppTextStyles.textField,
          decoration: const InputDecoration(
            labelText: 'Serial Number',
            labelStyle: AppTextStyles.textField,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(dialogContext).unfocus();
              final serialNumber = serialController.text.trim();
              if (serialNumber.isEmpty) {
                Navigator.pop(dialogContext);
                _showMessage(dialogContext, 'Serial number cannot be empty.');
                return;
              }

              final connected = await uartService.connect();
              if (!connected) {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  _showMessage(
                      dialogContext, 'Failed to connect to microcontroller.',);
                }
                return;
              }

              await uartService.sendJson({
                'username': username,
                'password': password,
                'serial_number': serialNumber,
              });

              final response = await uartService.readResponse();
              uartService.disconnect();

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                final message = _extractMessageFromResponse(response);
                _showMessage(
                    dialogContext, message ?? 'Serial number updated.',);
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String? _extractMessageFromResponse(String? response) {
    if (response == null || response.isEmpty) return null;
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(response) as Map<String, dynamic>;
      return decoded['message']?.toString();
    } catch (_) {
      return response;
    }
  }

  void _showMessage(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Info', style: AppTextStyles.title),
        content: Text(message, style: AppTextStyles.textField),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scan QR Code', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final rawValue = barcode.rawValue;
          if (rawValue != null) {
            _onQRScanned(context, rawValue);
          }
        },
      ),
    );
  }
}
