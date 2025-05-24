import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/cubits/connectivity_cubit.dart';
import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/pages/air_conditioner/cubit.dart';
import 'package:mobile/storage/user_storage.dart';
import 'package:uuid/uuid.dart';

class AddDeviceButton extends StatelessWidget {
  const AddDeviceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        final isConnected = state.isConnected;
        return IconButton(
          icon: const Icon(Icons.add, color: AppColors.primary),
          onPressed: isConnected
              ? () {
            final newAC = AirConditioner(
              id: const Uuid().v4(),
              userId: UserStorage.loggedUser!.id,
              location: 'New Location',
              temperature: 24,
              isOn: false,
            );
            context.read<AirConditionerCubit>().addAirConditioner(newAC);
          }
              : null,
          tooltip: isConnected ? 'Add device' : 'No internet',
        );
      },
    );
  }
}
