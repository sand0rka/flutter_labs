part of 'cubit.dart';

class MicrocontrollerState {
  final String serialNumber;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;

  const MicrocontrollerState({
    required this.serialNumber,
    required this.isLoading,
    this.errorMessage,
    this.infoMessage,
  });

  factory MicrocontrollerState.initial() => const MicrocontrollerState(
    serialNumber: 'Not fetched',
    isLoading: false,
  );

  MicrocontrollerState copyWith({
    String? serialNumber,
    bool? isLoading,
    String? errorMessage,
    String? infoMessage,
  }) {
    return MicrocontrollerState(
      serialNumber: serialNumber ?? this.serialNumber,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
    );
  }
}
