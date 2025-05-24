import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/cubits/user_cubit.dart';
import 'package:mobile/pages/profile/widgets/edit_user_dialog.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
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
    );
  }
}
