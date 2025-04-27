import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/components/app_colors.dart';
import 'package:mobile/components/app_text_styles.dart';
import 'package:mobile/components/custom_text_field.dart';
import 'package:mobile/components/primary_button.dart';
import 'package:mobile/cubits/auth_cubit.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/validation/registration_validator.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? size.width * 0.2 : 20,
              vertical: 20,
            ),
            child: Form(
              key: formKey,
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
                    controller: nameController,
                    labelText: 'Name',
                    validator: RegistrationValidator.validateName,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    validator: RegistrationValidator.validateEmail,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: RegistrationValidator.validatePassword,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Register',
                    isTablet: isTablet,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final emailExistsError =
                            await RegistrationValidator.validateEmailExists(
                          email,
                        );
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
                          name: nameController.text.trim(),
                          email: email,
                          password: passwordController.text.trim(),
                        );

                        context.read<AuthCubit>().register(user);
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
      ),
    );
  }
}
