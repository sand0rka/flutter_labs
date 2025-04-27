import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/storage/user_storage.dart';

class EditUserDialog extends StatefulWidget {
  final User user;
  final void Function(User) onUserUpdated;

  const EditUserDialog({
    required this.user,
    required this.onUserUpdated,
    super.key,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  final _storage = UserStorage();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updatedUser = User(
      id: widget.user.id,
      name: nameController.text,
      email: emailController.text,
      password: widget.user.password,
    );

    await _storage.updateUser(updatedUser);
    widget.onUserUpdated(updatedUser);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text(
        'Edit Info',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: nameController,
            labelText: 'Name',
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: emailController,
            labelText: 'Email',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.secondary),
          ),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
