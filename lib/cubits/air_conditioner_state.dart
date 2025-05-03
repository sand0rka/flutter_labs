part of 'air_conditioner_cubit.dart';

class AirConditionerState extends Equatable {
  final List<AirConditioner> airConditioners;
  final bool isLoading;

  const AirConditionerState({
    required this.airConditioners,
    required this.isLoading,
  });

  const AirConditionerState.initial()
      : airConditioners = const [],
        isLoading = false;

  const AirConditionerState.loading()
      : airConditioners = const [],
        isLoading = true;

  const AirConditionerState.loaded(List<AirConditioner> list)
      : airConditioners = list,
        isLoading = false;

  @override
  List<Object?> get props => [airConditioners, isLoading];
}
