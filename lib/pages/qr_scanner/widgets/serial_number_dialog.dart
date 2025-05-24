import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/services/uart_service.dart';

class SerialNumberDialog extends StatefulWidget {
  final String username;
  final String password;

  const SerialNumberDialog({
    required this.username,
    required this.password,
    super.key,
  });

  @override
  State<SerialNumberDialog> createState() => _SerialNumberDialogState();
}

class _SerialNumberDialogState extends State<SerialNumberDialog> {
  final serialController = TextEditingController();
  final uartService = UartService();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final serialNumber = serialController.text.trim();

    if (serialNumber.isEmpty) {
      Navigator.pop(context);
      _showMessage('Serial number cannot be empty.');
      return;
    }

    final connected = await uartService.connect();
    if (!connected) {
      if (mounted) {
        Navigator.pop(context);
        _showMessage('Failed to connect to microcontroller.');
      }
      return;
    }

    await uartService.sendJson({
      'username': widget.username,
      'password': widget.password,
      'serial_number': serialNumber,
    });

    final response = await uartService.readResponse();
    uartService.disconnect();

    if (mounted) {
      Navigator.pop(context);
      final message = _extractMessage(response) ?? 'Serial number updated.';
      _showMessage(message);
    }
  }

  String? _extractMessage(String? response) {
    if (response == null || response.isEmpty) return null;
    try {
      final decoded = jsonDecode(response);
      return decoded['message']?.toString();
    } catch (_) {
      return response;
    }
  }

  void _showMessage(String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
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
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Enter New Serial Number', style: AppTextStyles.title),
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
          onPressed: _submit,
          child:
              const Text('Update', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
