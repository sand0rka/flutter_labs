import 'dart:convert';
import 'dart:developer';

import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/storage/i_air_conditioner_storage.dart';
import 'package:mobile/storage/user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirConditionerStorage implements IAirConditionerStorage {
  static const _airConditionersKey = 'air_conditioners';

  @override
  Future<void> saveAirConditioners(List<AirConditioner> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((e) => e.toJSON()).toList());
    await prefs.setString(_airConditionersKey, encoded);
  }

  @override
  Future<List<AirConditioner>> getUserConditioners() async {
    final conditioners = await getAirConditioners();

    return conditioners
        .where((item) => item.userId == UserStorage.loggedUser?.id)
        .toList();
  }

  @override
  Future<List<AirConditioner>> getAirConditioners() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_airConditionersKey);
    if (raw == null || raw.isEmpty) return [];
    log(raw);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => AirConditioner.fromJSON(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteAirConditioner(String id) async {
    final list = await getAirConditioners();
    final updated = list.where((e) => e.id != id).toList();
    await saveAirConditioners(updated);
  }

  @override
  Future<void> clearUserAirConditioners() async {
    final list = await getAirConditioners();
    final updated =
        list.where((e) => e.userId != UserStorage.loggedUser?.id).toList();
    await saveAirConditioners(updated);
  }
}
