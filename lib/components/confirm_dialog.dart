import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(content, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.secondary),),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(confirmText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
