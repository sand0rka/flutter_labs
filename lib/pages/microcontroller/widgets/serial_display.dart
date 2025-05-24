import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class SerialDisplay extends StatelessWidget {
  final String serial;

  const SerialDisplay({required this.serial, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Current Serial Number:',
          style: AppTextStyles.textField,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            serial,
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
