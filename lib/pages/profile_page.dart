import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/edit_user_dialog.dart';
import 'package:mobile/components/navigation.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/storage/air_conditioner_storage.dart';
import 'package:mobile/storage/user_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  final _storage = UserStorage();
  final _airConditionerStorage = AirConditionerStorage();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = UserStorage.loggedUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    await _storage.logoutUser();
    navigator.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _deleteAccount() async {
    final navigator = Navigator.of(context);
    await _storage.deleteUser();
    await _airConditionerStorage.clearUserAirConditioners();

    navigator.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _showEditDialog() {
    if (_user == null) return;

    showDialog<void>(
      context: context,
      builder: (context) => EditUserDialog(
        user: _user!,
        onUserUpdated: (updatedUser) {
          setState(() {
            _user = updatedUser;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: _user == null ? null : _showEditDialog,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 100, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(_user!.name, style: AppTextStyles.textField),
                  Text(_user!.email, style: AppTextStyles.textField),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Log out',
                    isTablet: isTablet,
                    onPressed: _logout,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _deleteAccount,
                    child: const Text(
                      'Delete account',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
