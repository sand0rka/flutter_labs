import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class TemperatureSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const TemperatureSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Temperature:', style: AppTextStyles.label),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.secondary.withOpacity(0.3),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            valueIndicatorTextStyle:
            AppTextStyles.label.copyWith(color: Colors.black),
          ),
          child: Slider(
            value: value,
            min: 16,
            max: 30,
            divisions: 14,
            label: '${value.round()}°C',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
