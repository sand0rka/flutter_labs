import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubits/air_conditioner_cubit.dart';
import 'package:mobile/cubits/auth_cubit.dart';
import 'package:mobile/cubits/connectivity_cubit.dart';
import 'package:mobile/cubits/mqtt_cubit.dart';
import 'package:mobile/cubits/user_cubit.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/storage/user_storage.dart';

void main() {
  final userStorage = UserStorage();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConnectivityCubit()),
        BlocProvider(create: (_) => MqttCubit()),
        BlocProvider(create: (_) => AirConditionerCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(
          create: (context) {
            final cubit = AuthCubit(userStorage);
            cubit.checkAuth(context);
            return cubit;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) => current is AuthAuthenticated,
            listener: (context, state) {
              final isConnected =
                  context.read<ConnectivityCubit>().state.isConnected;
              if (!isConnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('No internet connection. Limited mode enabled.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return const HomePage();
                } else if (state is AuthUnauthenticated || state is AuthError) {
                  return const LoginPage();
                } else {
                  return const Scaffold(
                    backgroundColor: Colors.black,
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
