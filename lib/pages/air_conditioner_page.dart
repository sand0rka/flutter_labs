import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/components/power_switch.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/components/temperature_slider.dart';
import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/storage/air_conditioner_storage.dart';

class AirConditionerPage extends StatefulWidget {
  final AirConditioner ac;

  const AirConditionerPage({required this.ac, super.key});

  @override
  State<AirConditionerPage> createState() => _AirConditionerPageState();
}

class _AirConditionerPageState extends State<AirConditionerPage> {
  late TextEditingController locationController;
  late double temperature;
  late bool isOn;
  final _storage = AirConditionerStorage();

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController(text: widget.ac.location);
    temperature = widget.ac.temperature.toDouble();
    isOn = widget.ac.isOn;
  }

  Future<void> _save() async {
    final updatedAC = AirConditioner(
      id: widget.ac.id,
      userId: widget.ac.userId,
      location: locationController.text,
      temperature: temperature,
      isOn: isOn,
    );

    final list = await _storage.getAirConditioners();
    final index = list.indexWhere((e) => e.id == widget.ac.id);
    if (index != -1) {
      list[index] = updatedAC;
      await _storage.saveAirConditioners(list);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await _storage.deleteAirConditioner(widget.ac.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title:
            Text('Edit AC: ${widget.ac.location}', style: AppTextStyles.title),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: locationController,
              labelText: 'Location',
            ),
            const SizedBox(height: 24),
            TemperatureSlider(
              value: temperature,
              onChanged: (val) => setState(() => temperature = val),
            ),
            PowerSwitch(
              value: isOn,
              onChanged: (val) => setState(() => isOn = val),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Save',
                isTablet: isTablet,
                onPressed: _save,
              ),
            ),
            TextButton(
              onPressed: _delete,
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
    );
  }
}
