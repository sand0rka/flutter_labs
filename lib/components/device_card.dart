import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';

class DeviceCard extends StatefulWidget {
  final String location;

  const DeviceCard({
    required this.location,
    super.key,
  });

  @override
  DeviceCardState createState() => DeviceCardState();
}

class DeviceCardState extends State<DeviceCard> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.ac_unit,
            size: 40,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            widget.location,
            style: AppTextStyles.textField,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isOn = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isOn ? AppColors.background : AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OFF'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isOn = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isOn ? AppColors.primary : AppColors.background,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('ON'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
