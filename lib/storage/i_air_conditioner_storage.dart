import 'package:mobile/models/air_conditioner.dart';

abstract class IAirConditionerStorage {
  Future<void> saveAirConditioners(List<AirConditioner> list);
  Future<List<AirConditioner>> getUserConditioners();
  Future<List<AirConditioner>> getAirConditioners();
  Future<void> deleteAirConditioner(String id);
  Future<void> clearUserAirConditioners();
}
