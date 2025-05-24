import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/pages/microcontroller/cubit.dart';
import 'package:mobile/pages/microcontroller/widgets/qr_dialog.dart';
import 'package:mobile/pages/microcontroller/widgets/serial_display.dart';

class MicrocontrollerPage extends StatelessWidget {
  const MicrocontrollerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return BlocProvider(
      create: (_) => MicrocontrollerCubit(),
      child: BlocConsumer<MicrocontrollerCubit, MicrocontrollerState>(
        listener: (context, state) {
          final message = state.errorMessage ?? state.infoMessage;
          if (message != null) {
            _showMessage(context, message);
            context.read<MicrocontrollerCubit>().clearMessages();
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Microcontroller Configuration',
              style: AppTextStyles.title,
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SerialDisplay(serial: state.serialNumber),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Fetch Device Data',
                    isTablet: isTablet,
                    onPressed: () =>
                        context.read<MicrocontrollerCubit>().fetchSerial(),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Scan QR for Credentials',
                    isTablet: isTablet,
                    onPressed: () => showQrDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Info', style: AppTextStyles.title),
        content: Text(message, style: AppTextStyles.textField),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
