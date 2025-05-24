import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class InfoDialog extends StatelessWidget {
  final String message;

  const InfoDialog({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}
