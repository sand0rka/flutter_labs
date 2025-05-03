import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/components/power_switch.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/components/temperature_slider.dart';
import 'package:mobile/cubits/air_conditioner_cubit.dart';
import 'package:mobile/models/air_conditioner.dart';

class AirConditionerPage extends StatelessWidget {
  final AirConditioner ac;

  const AirConditionerPage({required this.ac, super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    final locationController = TextEditingController(text: ac.location);
    final temperatureNotifier =
        ValueNotifier<double>(ac.temperature.toDouble());
    final isOnNotifier = ValueNotifier<bool>(ac.isOn);

    void save() {
      final updatedAC = AirConditioner(
        id: ac.id,
        userId: ac.userId,
        location: locationController.text,
        temperature: temperatureNotifier.value,
        isOn: isOnNotifier.value,
      );

      context
          .read<AirConditionerCubit>()
          .updateAirConditionersTemperature(updatedAC.temperature);
      Navigator.pop(context);
    }

    void delete() {
      context.read<AirConditionerCubit>().deleteAirConditioner(ac.id);
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Edit AC: ${ac.location}', style: AppTextStyles.title),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: locationController,
                labelText: 'Location',
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<double>(
                valueListenable: temperatureNotifier,
                builder: (context, temp, _) {
                  return TemperatureSlider(
                    value: temp,
                    onChanged: (val) => temperatureNotifier.value = val,
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isOnNotifier,
                builder: (context, isOn, _) {
                  return PowerSwitch(
                    value: isOn,
                    onChanged: (val) => isOnNotifier.value = val,
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Save',
                  isTablet: isTablet,
                  onPressed: save,
                ),
              ),
              TextButton(
                onPressed: delete,
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
