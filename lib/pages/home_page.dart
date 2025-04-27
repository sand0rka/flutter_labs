import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/device_card.dart' as components;
import 'package:mobile/components/navigation.dart';
import 'package:mobile/cubits/air_conditioner_cubit.dart';
import 'package:mobile/cubits/connectivity_cubit.dart';
import 'package:mobile/cubits/mqtt_cubit.dart';
import 'package:mobile/models/air_conditioner.dart';
import 'package:mobile/pages/air_conditioner_page.dart';
import 'package:mobile/storage/user_storage.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            final connected = state.isConnected;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  connected ? 'Connection restored' : 'No internet connection',
                ),
                backgroundColor: connected ? Colors.green : Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        BlocListener<MqttCubit, MqttState>(
          listenWhen: (previous, current) =>
              previous.temperature != current.temperature,
          listener: (context, state) {
            if (state.temperature != null) {
              context
                  .read<AirConditionerCubit>()
                  .updateAirConditionersTemperature(state.temperature!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Air conditioners', style: AppTextStyles.title),
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            BlocBuilder<ConnectivityCubit, ConnectivityState>(
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
                          context
                              .read<AirConditionerCubit>()
                              .addAirConditioner(newAC);
                        }
                      : null,
                  tooltip: isConnected ? 'Add device' : 'No internet',
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        body: Column(
          children: [
            BlocBuilder<MqttCubit, MqttState>(
              builder: (context, state) {
                if (state.temperature != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'MQTT : ${state.temperature!.toStringAsFixed(1)}°C',
                      style: AppTextStyles.title,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<AirConditionerCubit, AirConditionerState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final airConditioners = state.airConditioners;

                  if (airConditioners.isEmpty) {
                    return const Center(
                      child: Text(
                        'No devices added yet.',
                        style: AppTextStyles.textField,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: airConditioners
                          .map(
                            (ac) => GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => AirConditionerPage(ac: ac),
                                  ),
                                );
                                if (context.mounted) {
                                  context
                                      .read<AirConditionerCubit>()
                                      .loadAirConditioners();
                                }
                              },
                              onLongPress: () {
                                context
                                    .read<AirConditionerCubit>()
                                    .deleteAirConditioner(ac.id);
                              },
                              child: components.DeviceCard(
                                location: ac.location,
                                temperature: ac.temperature,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
