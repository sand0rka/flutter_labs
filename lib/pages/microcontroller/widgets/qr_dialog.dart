import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/pages/microcontroller/cubit.dart';
import 'package:mobile/pages/qr_scanner/screen.dart';

Future<void> showQrDialog(BuildContext context) async {
  final localContext = context;

  final result = await Navigator.push<Map<String, String>>(
    localContext,
    MaterialPageRoute(builder: (_) => const QrScannerPage()),
  );

  if (!localContext.mounted) return;

  if (result == null ||
      !result.containsKey('username') ||
      !result.containsKey('password')) {
    return;
  }

  await _showSerialInputDialog(localContext, result);
}

Future<void> _showSerialInputDialog(
  BuildContext context,
  Map<String, String> credentials,
) async {
  final serialController = TextEditingController();

  await showDialog<void>(
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
            final serial = serialController.text.trim();
            if (serial.isEmpty) {
              Navigator.pop(dialogContext);
              await _showError(context, 'Serial number cannot be empty.');
              return;
            }

            Navigator.pop(dialogContext);
            if (context.mounted) {
              context.read<MicrocontrollerCubit>().updateSerial(
                    serial: serial,
                    username: credentials['username']!,
                    password: credentials['password']!,
                  );
            }
          },
          child:
              const Text('Update', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    ),
  );
}

Future<void> _showError(BuildContext context, String message) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Error', style: AppTextStyles.title),
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
