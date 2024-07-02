import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/common/theme/colors.dart';
import 'package:tracking_app/common/utils/validator.dart';
import 'package:tracking_app/common/widgets/custom_elevated_button.dart';
import 'package:tracking_app/common/widgets/dialogs.dart';
import 'package:tracking_app/common/widgets/text_input_field.dart';
import 'package:tracking_app/data/domain/user.dart';
import 'package:tracking_app/feature/auth/register/bloc/registration_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  static const String name = 'RegistrationScreen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ///At first the button is disabled,
  ///until all the input fields are filled.
  bool _isRegisterButtonEnabled = false;

  ///Controllers to retrieve the text from the input fields.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<RegistrationBloc>(context).add(ResetRegistrationState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: _handleRegistrationStates,
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Registration",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: AppColors.primary,
          ),
          backgroundColor: AppColors.surface,
          body: Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 16),
                          child: _getRegistrationDescription(context),
                        ),
                        Form(
                          onChanged: () => setState(
                            () {
                              if (state is RegistrationError) {
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(ResetRegistrationState());
                              }
                              _isRegisterButtonEnabled = _validateForm(context);
                            },
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: TextInputField(
                                  labelText: "First Name",
                                  hintText: "Judy",
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _firstNameController,
                                  validator: (s) => Validator.validateName(
                                    s,
                                  ),
                                  enableSpaceKey: true,
                                  onlyAlpha: true,
                                ),
                              ),
                              TextInputField(
                                labelText: "Last Name",
                                hintText: "Petterson",
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _lastNameController,
                                validator: (s) => Validator.validateName(
                                  s,
                                ),
                                enableSpaceKey: true,
                                onlyAlpha: true,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: TextInputField(
                                  labelText: "Email address",
                                  hintText: "judy@email.com",
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: (s) => _validateEmail(s, state),
                                ),
                              ),
                              TextInputField(
                                labelText: "Password",
                                hintText: "********",
                                type: TextInputFieldType.password,
                                controller: _passController,
                                validator: (s) => Validator.validatePass(s),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: TextInputField(
                                  labelText: "Confirm password",
                                  hintText: "********",
                                  type: TextInputFieldType.password,
                                  controller: _confirmPassController,
                                  validator: (confPass) =>
                                      Validator.validateConfirmPass(
                                          confPass, _passController.text),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomElevatedButton(
                  text: "Create Account",
                  onPressed: _isRegisterButtonEnabled
                      ? () {
                          if (state is! RegistrationLoading) {
                            _signUp(context);
                          }
                        }
                      : null,
                  isLoading: state is RegistrationLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _validateEmail(String? s, RegistrationState state) {
    if (state is RegistrationError) {
      if (state.status == RegistrationErrorStatus.userAlreadyExists) {
        return "User already exists";
      }
    }
    return Validator.validateEmail(s);
  }

  void _handleRegistrationStates(
      BuildContext context, RegistrationState state) {
    if (state is RegistrationError) {
      if (state.status == RegistrationErrorStatus.unknownError) {
        GenericDialogs.somethingWentWrong().showOSDialog(context);
      } else if (state.status == RegistrationErrorStatus.networkError) {
        GenericDialogs.networkError().showOSDialog(context);
      } else if (state.status == RegistrationErrorStatus.invalidEmailFormat) {
        NativeDialog(
          title: "Invalid Email Address",
          content:
              "You have entered an invalid email address. Please enter a valid one and try again!",
          firstButtonText: "Ok",
        ).showOSDialog(context);
      }
    }
    if (state is RegistrationSuccess) {
      log("registration Success");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created Successfully"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// returns the text for the registration subtitle,
  /// one part as normal weight and one part as bold.
  Widget _getRegistrationDescription(BuildContext context) {
    return Text(
      "Please enter your details to create a new account",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.secondary,
          ),
    );
  }

  void _signUp(BuildContext context) {
    User user = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text.toLowerCase(),
      password: _passController.text,
    );
    BlocProvider.of<RegistrationBloc>(context)
        .add(RegistrationButtonPressed(user));
  }

  bool _validateForm(BuildContext context) {
    return Validator.validateName(_firstNameController.text) == null &&
        Validator.validateName(_lastNameController.text) == null &&
        Validator.validateEmail(_emailController.text) == null &&
        Validator.validatePass(_passController.text) == null &&
        Validator.validateConfirmPass(
                _confirmPassController.text, _passController.text) ==
            null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
}
