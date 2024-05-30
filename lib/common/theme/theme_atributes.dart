import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_app/common/theme/colors.dart';

class ThemeAttributes {
  final bool _isLightTheme;
  static const double _radius = 2;

  ThemeAttributes(this._isLightTheme);

  TextTheme get textTheme {
    var color = _isLightTheme ? AppColors.black : AppColors.white;
    var colorBlack = _isLightTheme ? AppColors.black : AppColors.white;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        height: 1.12,
        // 64px
        fontFamily: FontFamilies.instagridHeadline,
        color: colorBlack,
        letterSpacing: -0.25,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
          fontSize: 45,
          height: 1.15,
          // 52px
          fontFamily: FontFamilies.instagridHeadline,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          letterSpacing: 0),
      displaySmall: TextStyle(
          fontSize: 36,
          height: 1.22,
          // 44px
          fontFamily: FontFamilies.instagridHeadline,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          letterSpacing: 0),
      headlineLarge: TextStyle(
          fontSize: 32,
          height: 1.25,
          // 40px
          color: colorBlack,
          fontWeight: FontWeight.w500,
          letterSpacing: 0),
      headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.28,
          // 36px
          color: colorBlack,
          fontWeight: FontWeight.w400,
          letterSpacing: 0),
      headlineSmall: TextStyle(
          fontSize: 24,
          height: 1.33,
          // 32px
          color: colorBlack,
          fontWeight: FontWeight.w400,
          letterSpacing: 0),
      titleLarge: TextStyle(
          fontSize: 22,
          height: 1.27,
          // 24px
          color: colorBlack,
          fontFamily: FontFamilies.latteraMedium,
          fontWeight: FontWeight.w500,
          letterSpacing: 0),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        // 24px
        color: color,
        fontFamily: FontFamilies.latteraMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.42,
        // 20px
        color: color,
        fontFamily: FontFamilies.latteraMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        height: 1.25,
        // 20px
        color: color,
        fontFamily: FontFamilies.latteraMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        height: 1.14,
        // 16px
        color: color,
        fontFamily: FontFamilies.latteraMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        // 16 px
        fontFamily: FontFamilies.latteraMedium,
        color: color,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        // 24 px
        color: color,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.42,
        // 20px
        color: color,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        // 16px
        color: color,
        fontFamily: FontFamilies.latteraMedium,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );
  }

  get colorScheme => ColorScheme(
      brightness: _isLightTheme ? Brightness.light : Brightness.dark,
      primary: AppColors.primary,
      onPrimary: _isLightTheme ? AppColors.white : AppColors.black,
      secondary: AppColors.secondary,
      onSecondary: _isLightTheme ? AppColors.white : AppColors.black,
      error: AppColors.errorRed,
      onError: _isLightTheme ? AppColors.black : AppColors.white,
      background: _isLightTheme ? AppColors.white : AppColors.black,
      onBackground: _isLightTheme ? AppColors.black : AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.surface);

  get textButtonThemeData => TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(textTheme.labelLarge),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.black.withOpacity(0.4);
        }
        return AppColors.primary;
      }),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStateProperty.all(EdgeInsets.zero),
    ),
  );

  get switchTheme => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.white;
      }
      return AppColors.black;
    }),
    overlayColor: MaterialStateProperty.all(AppColors.primary),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.white;
    }),
    trackOutlineColor: MaterialStateProperty.all(AppColors.black),
    trackOutlineWidth: MaterialStateProperty.all(1),
    thumbIcon: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.circle,
          color: AppColors.white,
        );
      }
      return const Icon(
        Icons.circle,
        color: AppColors.black,
      );
    }),
  );

  get elevatedButtonThemeData => ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      surfaceTintColor: MaterialStateProperty.all(AppColors.transparent),
      textStyle: MaterialStateProperty.all(textTheme.labelLarge),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.black.withOpacity(0.4);
        }
        return AppColors.white;
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.black.withOpacity(0.1);
        }
        return AppColors.primary;
      }),
      fixedSize:
      MaterialStateProperty.all(const Size(double.maxFinite, 52)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
      overlayColor: MaterialStateProperty.all(
        AppColors.white.withOpacity(0.1),
      ),
    ),
  );

  get outlineButtonThemeData => OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(textTheme.labelLarge),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.black.withOpacity(0.4);
        }
        return AppColors.white;
      }),
      fixedSize:
      MaterialStateProperty.all(const Size(double.maxFinite, 52)),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: AppColors.black.withOpacity(0.4));
        }
        return const BorderSide(color: AppColors.primary);
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
    ),
  );

  get appBarTheme => AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    color: AppColors.surface,
    iconTheme: IconThemeData(
        color: _isLightTheme ? AppColors.black : AppColors.white),
  );

  get inputDecorationTheme => InputDecorationTheme(
    helperStyle: textTheme.bodySmall
        ?.copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
    focusColor: AppColors.primary,
    hoverColor: AppColors.primary,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintStyle: textTheme.bodyLarge?.copyWith(
      foreground: Paint()..color = AppColors.black,
    ),
    labelStyle: textTheme.bodyLarge?.copyWith(
      foreground: Paint()..color = AppColors.black,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: const BorderSide(color: AppColors.black),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: const BorderSide(color: AppColors.errorRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: const BorderSide(color: AppColors.errorRed),
    ),
    errorMaxLines: 4,
    errorStyle: textTheme.bodySmall
        ?.copyWith(color: AppColors.errorRed, fontWeight: FontWeight.w500),
    contentPadding: const EdgeInsets.all(16),
  );

  get snackBarTheme => SnackBarThemeData(
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.white,
    insetPadding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(36),
    ),
    actionTextColor: AppColors.primary,
    contentTextStyle: textTheme.bodyLarge,
  );

  get checkBoxTheme => CheckboxThemeData(
    checkColor: MaterialStateProperty.all(AppColors.primary),
    fillColor: MaterialStateProperty.all(AppColors.white),
    side: MaterialStateBorderSide.resolveWith(
          (states) => const BorderSide(color: AppColors.primary, width: 2.0),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.5)),
    ),
  );

  get radioButtonTheme => RadioThemeData(
    fillColor: MaterialStateProperty.all(AppColors.primary),
  );

  get listTileTheme => const ListTileThemeData(tileColor: AppColors.white);

  get navigationBarTheme => NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.accent,
    labelTextStyle: MaterialStatePropertyAll(textTheme.labelSmall),
  );

  get floatingActionButtonTheme => FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    iconSize: 42,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  );

  get cardTheme => const CardTheme(
    color: Colors.white,
  );

  get popupMenuTheme => const PopupMenuThemeData(
    color: AppColors.white,
  );

  get dialogTheme => const DialogTheme(
    backgroundColor: AppColors.surface,
  );

  get bottomSheetTheme => const BottomSheetThemeData(
    backgroundColor: AppColors.white,
  );
}


class FontFamilies{
  static const String instagridHeadline = "InstagridHeadline";
  static const String latteraMedium = "LatteraMedium";
  static const String lattera = "Lattera";
}