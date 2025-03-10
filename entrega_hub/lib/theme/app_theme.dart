import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'button_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    textTheme: TextTheme(
      displayLarge: TextStyles.headline1,
      bodyLarge: TextStyles.bodyText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyles.elevatedButtonStyle,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple,
    ).copyWith(
      secondary: AppColors.accentColor,
      background: AppColors.backgroundColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: AppColors.textColor,
      onSurface: AppColors.textColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.accentColor,
    textTheme: TextTheme(
      displayLarge: TextStyles.headline1.copyWith(color: Colors.white),
      bodyLarge: TextStyles.bodyText.copyWith(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyles.elevatedButtonStyle,
    ),
    colorScheme: ColorScheme.dark().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      background: Colors.black,
      surface: Colors.grey[900],
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white70,
      onSurface: Colors.white70,
    ),
  );
}