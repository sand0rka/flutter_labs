import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/cubits/mqtt_cubit.dart';

class MqttTemperatureDisplay extends StatelessWidget {
  const MqttTemperatureDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttCubit, MqttState>(
      builder: (context, state) {
        if (state.temperature != null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'MQTT : ${state.temperature!.toStringAsFixed(1)}°C',
              style: AppTextStyles.title,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
