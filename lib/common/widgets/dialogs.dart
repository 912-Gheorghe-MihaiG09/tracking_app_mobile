import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NativeDialog {
  final String title;
  final String content;
  final String? firstButtonText;
  VoidCallback? onFirstButtonPress;
  final String? secondButtonText;
  VoidCallback? onSecondButtonPress;
  final bool isLoadingDialog;

  NativeDialog({
    required this.title,
    required this.content,
    this.firstButtonText,
    this.onFirstButtonPress,
    this.secondButtonText,
    this.onSecondButtonPress,
    this.isLoadingDialog = false,
  });

  /// show the OS Native dialog
  void showOSDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return isLoadingDialog
              ? PopScope(
                  canPop: false,
                  child: _iosDialog(context),
                )
              : _iosDialog(context);
        } else {
          return isLoadingDialog
              ? PopScope(
                  canPop: false,
                  child: _androidDialog(context),
                )
              : _androidDialog(context);
        }
      },
    );
  }

  /// show the android Native dialog
  Widget _androidDialog(BuildContext context) {
    List<Widget> actions = [];
    if (firstButtonText != null) {
      actions.add(
        TextButton(
          onPressed: onFirstButtonPress ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(
            firstButtonText!,
          ),
        ),
      );
    }

    if (secondButtonText != null) {
      actions.add(
        TextButton(
          onPressed: onSecondButtonPress ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(
            secondButtonText!,
          ),
        ),
      );
    }

    if (isLoadingDialog) {
      actions.add(
        const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        actions: actions);
  }

  /// show the iOS Native dialog
  Widget _iosDialog(BuildContext context) {
    List<Widget> actions = [];

    if (firstButtonText != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onFirstButtonPress ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(
            firstButtonText!,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: CupertinoColors.systemBlue,
            ),
          ),
        ),
      );
    }

    if (secondButtonText != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onSecondButtonPress ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(
            secondButtonText!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemBlue,
            ),
          ),
        ),
      );
    }

    if (isLoadingDialog) {
      actions.add(
        const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(

            ),
          ),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: actions,
    );
  }

  NativeDialog copyWith({
    String? title,
    String? content,
    String? firstButtonText,
    VoidCallback? onFirstButtonPress,
    String? secondButtonText,
    VoidCallback? onSecondButtonPress,
    bool? isLoadingDialog,
  }) =>
      NativeDialog(
        title: title ?? this.title,
        content: content ?? this.content,
        firstButtonText: firstButtonText ?? this.firstButtonText,
        onFirstButtonPress: onFirstButtonPress ?? this.onFirstButtonPress,
        secondButtonText: secondButtonText ?? this.secondButtonText,
        onSecondButtonPress: onSecondButtonPress ?? this.onSecondButtonPress,
        isLoadingDialog: isLoadingDialog ?? this.isLoadingDialog,
      );
}

class GenericDialogs {

  static NativeDialog somethingWentWrong() => NativeDialog(
      title: "Oops",
      firstButtonText: "Ok",
      content: "Something went wrong, please try again!");

  static NativeDialog networkError() => NativeDialog(
        title: "No internet Connection",
        content: "Please check your internet connection then try again",
        firstButtonText: "ok",
      );
}
