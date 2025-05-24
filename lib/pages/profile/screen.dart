import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/navigation.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/cubits/auth_cubit.dart';
import 'package:mobile/cubits/user_cubit.dart';
import 'package:mobile/pages/microcontroller/screen.dart';
import 'package:mobile/pages/profile/widgets/confirm_dialog.dart';
import 'package:mobile/pages/profile/widgets/edit_user_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final user = state.user;
              return IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary),
                onPressed: user == null
                    ? null
                    : () => showDialog<void>(
                          context: context,
                          builder: (_) => EditUserDialog(
                            user: user,
                            onUserUpdated: (updatedUser) {
                              context.read<UserCubit>().updateUser(updatedUser);
                            },
                          ),
                        ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final user = state.user;

          if (state.isDeleted) {
            return const Center(
              child: Text('User deleted.', style: AppTextStyles.textField),
            );
          }

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 100, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(user.name, style: AppTextStyles.textField),
                Text(user.email, style: AppTextStyles.textField),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Log out',
                  isTablet: isTablet,
                  onPressed: () => _showConfirmDialog(
                    context,
                    title: 'Log out',
                    content: 'Are you sure you want to log out?',
                    confirmText: 'Log out',
                    onConfirm: () {
                      Navigator.of(context).pop();
                      context.read<AuthCubit>().logout();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Configure Microcontroller',
                  isTablet: isTablet,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const MicrocontrollerPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _showConfirmDialog(
                    context,
                    title: 'Delete account',
                    content: 'This action will delete your profile. Continue?',
                    confirmText: 'Delete',
                    onConfirm: () {
                      final navigator = Navigator.of(context);
                      context.read<UserCubit>().deleteUser();
                      context.read<AuthCubit>().logout();
                      navigator.pushNamedAndRemoveUntil('/login', (_) => false);
                    },
                  ),
                  child: const Text(
                    'Delete account',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }
}
