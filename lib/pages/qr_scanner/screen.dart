import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/pages/qr_scanner/widgets/serial_number_dialog.dart';
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
          showDialog<void>(
            context: context,
            builder: (_) => SerialNumberDialog(
              username: username,
              password: password,
            ),
          );
        });
        return;
      }

      _showMessage(context, 'QR code does not contain valid credentials.');
    } catch (_) {
      _showMessage(context, 'Failed to parse QR code.');
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
