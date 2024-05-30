import 'package:flutter/material.dart';
import 'package:tracking_app/common/theme/theme_atributes.dart';

import 'colors.dart';

class ThemeBuilder extends ChangeNotifier {
  late bool _isLightTheme;

  bool get isLightTheme => _isLightTheme;

  ThemeBuilder() {
    _isLightTheme = true;
  }

  set setIsLightTheme(bool isLightTheme) {
    _isLightTheme = isLightTheme;
    notifyListeners();
  }

  static ThemeData getThemeData(bool isLightTheme) {
    var attr = ThemeAttributes(isLightTheme);
    return ThemeData(
      splashColor: AppColors.transparent,
      floatingActionButtonTheme: attr.floatingActionButtonTheme,
      navigationBarTheme: attr.navigationBarTheme,
      bottomSheetTheme: attr.bottomSheetTheme,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.surface,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          surfaceTint: AppColors.transparent,
          error: AppColors.errorRed),
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      textTheme: attr.textTheme,
      fontFamily: FontFamilies.lattera,
      appBarTheme: attr.appBarTheme,
      cardTheme: attr.cardTheme,
      textButtonTheme: attr.textButtonThemeData,
      elevatedButtonTheme: attr.elevatedButtonThemeData,
      outlinedButtonTheme: attr.outlineButtonThemeData,
      inputDecorationTheme: attr.inputDecorationTheme,
      scaffoldBackgroundColor:
      isLightTheme ? AppColors.surface : AppColors.black,
      switchTheme: attr.switchTheme,
      snackBarTheme: attr.snackBarTheme,
      checkboxTheme: attr.checkBoxTheme,
      radioTheme: attr.radioButtonTheme,
      listTileTheme: attr.listTileTheme,
      popupMenuTheme: attr.popupMenuTheme,
      dialogTheme: attr.dialogTheme,
    );
  }
}
