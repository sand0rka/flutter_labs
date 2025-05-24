import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const ConnectivityState.unknown()) {
    _init();
  }

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    emit(ConnectivityState.fromResult(result));

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      emit(ConnectivityState.fromResult(result));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
