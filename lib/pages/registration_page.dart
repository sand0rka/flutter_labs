import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/storage/user_storage.dart';
import 'package:mobile/validation/registration_validator.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _storage = UserStorage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? size.width * 0.2 : 20,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  validator: RegistrationValidator.validateName,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  validator: RegistrationValidator.validateEmail,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: RegistrationValidator.validatePassword,
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Register',
                  isTablet: isTablet,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text.trim();
                      final emailExistsError =
                      await RegistrationValidator.validateEmailExists(email);
                      if (!context.mounted) return;
                      if (emailExistsError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(emailExistsError),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      final user = User(
                        id: const Uuid().v4(),
                        name: _nameController.text.trim(),
                        email: email,
                        password: _passwordController.text.trim(),
                      );

                      await _storage.registerUser(user);

                      if (!context.mounted) return;

                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Sign in',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
