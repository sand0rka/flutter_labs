import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/device_card.dart';
import 'package:mobile/components/navigation.dart';
import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/pages/air_conditioner_page.dart';
import 'package:mobile/storage/air_conditioner_storage.dart';
import 'package:mobile/storage/user_storage.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = AirConditionerStorage();
  List<AirConditioner> _airConditioners = [];

  @override
  void initState() {
    super.initState();
    _loadAirConditioners();
  }

  Future<void> _loadAirConditioners() async {
    final list = await _storage.getUserConditioners();
    setState(() {
      _airConditioners = list;
    });
  }

  Future<void> _addAirConditioner() async {
    final newAC = AirConditioner(
      id: const Uuid().v4(),
      userId: UserStorage.loggedUser!.id,
      location: 'New Location',
      temperature: 24,
      isOn: false,
    );
    final list = await _storage.getAirConditioners();

    list.add(newAC);
    await _storage.saveAirConditioners(list);
    await _loadAirConditioners();
    setState(() {});
  }

  Future<void> _editAirConditioner(AirConditioner ac) async {
    final updatedAC = AirConditioner(
      id: ac.id,
      userId: ac.userId,
      location: '${ac.location} (edited)',
      temperature: ac.temperature + 1,
      isOn: !ac.isOn,
    );
    final list = await _storage.getAirConditioners();
    final index = list.indexWhere((e) => e.id == ac.id);
    if (index != -1) {
      list[index] = updatedAC;
      await _storage.saveAirConditioners(list);
      setState(() {});
    }
  }

  Future<void> _deleteAirConditioner(String id) async {
    await _storage.deleteAirConditioner(id);
    await _loadAirConditioners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Air conditioners', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: _addAirConditioner,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: _airConditioners
              .map(
                (ac) => GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => AirConditionerPage(ac: ac),
                      ),
                    );
                    _loadAirConditioners();
                  },
                  onLongPress: () => _deleteAirConditioner(ac.id),
                  child: DeviceCard(location: ac.location),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
