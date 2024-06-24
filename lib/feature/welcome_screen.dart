import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/feature/auth/login/login_screen.dart';
import 'package:tracking_app/feature/auth/register/registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _normalButtonSection(context),
          ],
        ),
      ),
    );
  }

  Widget _normalButtonSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomElevatedButton(
              text: "Register New Account",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegistrationScreen(),
                ));
              },
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                const TextSpan(
                  text: "Already have an account?",
                ),
                TextSpan(
                  text: " Login!",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
