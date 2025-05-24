part of 'connectivity_cubit.dart';

enum ConnectionType { wifi, mobile, none, unknown }

class ConnectivityState extends Equatable {
  final ConnectionType type;
  final bool isConnected;

  const ConnectivityState._(this.type, this.isConnected);

  const ConnectivityState.unknown() : this._(ConnectionType.unknown, false);

  factory ConnectivityState.fromResult(ConnectivityResult result) {
    final type = result.toConnectionType();
    return ConnectivityState._(type, type.isConnected);
  }

  @override
  List<Object?> get props => [type, isConnected];
}

extension on ConnectionType {
  bool get isConnected =>
      this == ConnectionType.wifi || this == ConnectionType.mobile;
}

extension on ConnectivityResult {
  ConnectionType toConnectionType() {
    switch (this) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.none:
        return ConnectionType.none;
      default:
        return ConnectionType.unknown;
    }
  }
}
