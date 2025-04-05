import 'package:flutter/material.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/custom_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

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
                controller: _emailController,
                labelText: 'Email',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: isTablet ? 60 : 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: AppTextStyles.button,
                ),
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
    );
  }
}
