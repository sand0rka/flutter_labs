import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class SerialInputDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String serial) onConfirm;

  const SerialInputDialog({
    required this.controller,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Enter Serial Number', style: AppTextStyles.title),
      content: TextField(
        controller: controller,
        style: AppTextStyles.textField,
        decoration: const InputDecoration(
          labelText: 'Serial Number',
          labelStyle: AppTextStyles.textField,
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final serial = controller.text.trim();
            Navigator.pop(context);
            onConfirm(serial);
          },
          child:
              const Text('Update', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
