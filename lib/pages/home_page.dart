import 'package:flutter/material.dart';
import 'package:mobile/components//app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/device_card.dart';
import 'package:mobile/components/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Air conditioners', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            DeviceCard(location: 'Living Room'),
            DeviceCard(location: 'Bedroom'),
            DeviceCard(location: 'Kitchen'),
            DeviceCard(location: 'Office'),
          ],
        ),
      ),
    );
  }
}
