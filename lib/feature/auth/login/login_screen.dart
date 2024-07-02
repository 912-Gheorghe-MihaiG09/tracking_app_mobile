import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/utils/validator.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/common/widgets/text_input_field.dart';
import 'package:tracking_app/feature/auth/login/bloc/auth_bloc.dart';
import '../../../../common/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  ///At first the button is disabled,
  ///until the email and the password input fields are filled.
  bool _isLoginButtonEnabled = false;

  ///Controllers to retrieve the text from the input fields.
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Login",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _getLoginDescription(),
                    Form(
                      onChanged: () => setState(
                        () {
                          _isLoginButtonEnabled = _validateForm();
                        },
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: TextInputField(
                              labelText: "Email",
                              hintText: "Judy09@mail.com",
                              keyboardType: TextInputType.text,
                              controller: _emailController,
                              validator: Validator.validateEmail,
                            ),
                          ),
                          TextInputField(
                            labelText: "Password",
                            hintText: "At least 8 characters long.",
                            type: TextInputFieldType.password,
                            controller: _passController,
                            validator: Validator.validatePass,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _getResetPassword(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: CustomElevatedButton(
                text: "Login",
                onPressed: _isLoginButtonEnabled
                    ? () {
                        BlocProvider.of<AuthBloc>(context).add(LogIn(
                            email: _emailController.text,
                            password: _passController.text));
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// returns the text for the login subtitle,
  /// one part as normal weight and one part as bold.
  Widget _getLoginDescription() {
    return Text(
      "Please enter your account details in order to login",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.secondary,
          ),
    );
  }

  /// returns the text for reset password,
  /// one part as normal weight and one part as bold.
  Widget _getResetPassword(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(text: "${"Forgot your password?"} "),
          TextSpan(
            text: "Reset password!",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    return Validator.validateEmail(_emailController.text) == null &&
        Validator.validatePass(_passController.text) == null;
  }

  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
