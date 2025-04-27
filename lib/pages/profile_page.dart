import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/confirm_dialog.dart';
import 'package:mobile/components/edit_user_dialog.dart';
import 'package:mobile/components/navigation.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/cubits/auth_cubit.dart';
import 'package:mobile/cubits/user_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    : () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => EditUserDialog(
                            user: user,
                            onUserUpdated: (updatedUser) {
                              context.read<UserCubit>().updateUser(updatedUser);
                            },
                          ),
                        );
                      },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isDeleted) {
            return const Center(
              child: Text('User deleted.', style: AppTextStyles.textField),
            );
          }

          if (state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user!;

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
                  isTablet: MediaQuery.of(context).size.width > 600,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) => ConfirmDialog(
                        title: 'Log out',
                        content: 'Are you sure you want to log out?',
                        confirmText: 'Log out',
                        onConfirm: () {
                          Navigator.of(dialogContext).pop();
                          context.read<AuthCubit>().logout();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'Delete account',
                        content:
                            'This action will delete your profile. Continue?',
                        confirmText: 'Delete',
                        onConfirm: () {
                          final navigator = Navigator.of(context);
                          context.read<UserCubit>().deleteUser();
                          context.read<AuthCubit>().logout();
                          navigator.pushNamedAndRemoveUntil(
                            '/login',
                            (route) => false,
                          );
                        },
                      ),
                    );
                  },
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
}
