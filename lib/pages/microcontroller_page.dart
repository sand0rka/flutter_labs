import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/pages/qr_scanner_page.dart';
import 'package:mobile/services/uart_service.dart';

class MicrocontrollerPage extends StatefulWidget {
  const MicrocontrollerPage({super.key});

  @override
  State<MicrocontrollerPage> createState() => _MicrocontrollerPageState();
}

class _MicrocontrollerPageState extends State<MicrocontrollerPage> {
  final _uartService = UartService();
  String _currentSerial = 'Not fetched';

  Future<void> _fetchSerialNumber() async {
    final connected = await _uartService.connect();
    if (!connected) {
      if (mounted) {
        _showMessage('Failed to connect to microcontroller.');
      }
      return;
    }

    await _uartService.sendJson({'action': 'read_serial'});
    final response = await _uartService.readResponse();
    _uartService.disconnect();

    final message = _extractMessageFromResponse(response);

    if (mounted) {
      setState(() {
        _currentSerial = message ?? 'No response';
      });
    }
  }

  String? _extractMessageFromResponse(String? response) {
    if (response == null) return null;
    try {
      final Map<String, dynamic> jsonResponse =
      jsonDecode(response) as Map<String, dynamic>;
      return jsonResponse['message']?.toString();
    } catch (_) {
      return response;
    }
  }

  void _navigateToQrScanner() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (!mounted) return;

    if (result != null &&
        result.containsKey('username') &&
        result.containsKey('password')) {
      final username = result['username']!;
      final password = result['password']!;
      _showSerialInputDialog(username, password);
    }
  }

  void _showSerialInputDialog(String username, String password) {
    final serialController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter Serial Number', style: AppTextStyles.title),
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
              final serialNumber = serialController.text.trim();
              if (serialNumber.isEmpty) {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  _showMessage('Serial number cannot be empty.');
                }
                return;
              }

              final connected = await _uartService.connect();
              if (!connected) {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  _showMessage('Failed to connect to microcontroller.');
                }
                return;
              }

              await _uartService.sendJson({
                'username': username,
                'password': password,
                'serial_number': serialNumber,
              });

              final response = await _uartService.readResponse();
              _uartService.disconnect();

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

              if (!mounted) return;

              setState(() {
                _currentSerial = serialNumber;
              });

              final message = _extractMessageFromResponse(response);
              _showMessage(message ?? 'Serial number updated.');
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

  void _showMessage(String message) {
    if (!mounted) return;
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
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Microcontroller Configuration',
            style: AppTextStyles.title,),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Serial Number:',
                  style: AppTextStyles.textField,),
              const SizedBox(height: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentSerial,
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Fetch Device Data',
                isTablet: isTablet,
                onPressed: _fetchSerialNumber,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Scan QR for Credentials',
                isTablet: isTablet,
                onPressed: _navigateToQrScanner,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
