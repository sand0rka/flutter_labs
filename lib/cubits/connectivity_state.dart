part of 'connectivity_cubit.dart';

enum ConnectionType { wifi, mobile, none, unknown }

class ConnectivityState extends Equatable {
  final ConnectionType type;

  const ConnectivityState(this.type);

  const ConnectivityState.unknown() : type = ConnectionType.unknown;

  factory ConnectivityState.fromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return const ConnectivityState(ConnectionType.wifi);
      case ConnectivityResult.mobile:
        return const ConnectivityState(ConnectionType.mobile);
      case ConnectivityResult.none:
        return const ConnectivityState(ConnectionType.none);
      default:
        return const ConnectivityState(ConnectionType.unknown);
    }
  }

  bool get isConnected =>
      type == ConnectionType.wifi || type == ConnectionType.mobile;

  @override
  List<Object?> get props => [type];
}
