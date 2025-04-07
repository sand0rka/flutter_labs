import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class PowerSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PowerSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Power', style: AppTextStyles.textField),
      activeColor: AppColors.primary,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withOpacity(0.4),
      value: value,
      onChanged: onChanged,
    );
  }
}
