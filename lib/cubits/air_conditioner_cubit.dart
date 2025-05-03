import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/storage/air_conditioner_storage.dart';

part 'air_conditioner_state.dart';

class AirConditionerCubit extends Cubit<AirConditionerState> {
  final AirConditionerStorage _storage = AirConditionerStorage();

  AirConditionerCubit() : super(const AirConditionerState.initial()) {
    loadAirConditioners();
  }

  Future<void> loadAirConditioners() async {
    emit(const AirConditionerState.loading());
    final list = await _storage.getUserConditioners();
    emit(AirConditionerState.loaded(List<AirConditioner>.from(list)));
  }

  Future<void> addAirConditioner(AirConditioner ac) async {
    final list = await _storage.getAirConditioners();
    list.add(ac);
    await _storage.saveAirConditioners(list);
    await loadAirConditioners();
  }

  Future<void> deleteAirConditioner(String id) async {
    await _storage.deleteAirConditioner(id);
    await loadAirConditioners();
  }

  Future<void> updateAirConditionersTemperature(double temperature) async {
    final list = await _storage.getAirConditioners();
    final updatedList =
        list.map((ac) => ac.copyWith(temperature: temperature)).toList();
    await _storage.saveAirConditioners(updatedList);
    await loadAirConditioners();
  }
}
