import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gracieusgalerij/screens/theme/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;
  ThemeProvider({required this.isLightTheme});

  getCurrentStatusNavigationBarColor() {
    if (isLightTheme) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.navColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  toggleThemeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (isLightTheme) {
      sharedPreferences.setBool(SPref.isLight, false);
      isLightTheme = !isLightTheme;
      notifyListeners();
    } else {
      sharedPreferences.setBool(SPref.isLight, true);
      isLightTheme = !isLightTheme;
      notifyListeners();
    }
    getCurrentStatusNavigationBarColor();
  }

  ThemeData themeData() {
    return ThemeData(
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: isLightTheme ? AppColors.white : AppColors.dark1,
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: 'Bayon',
          fontSize: 25,
          color: isLightTheme ? AppColors.black : AppColors.white,
        ),
        headline2: TextStyle(
          fontFamily: 'Basic',
          fontSize: 16,
          color: isLightTheme ? AppColors.black : AppColors.white,
        ),
        headline3: TextStyle(
          fontFamily: 'Bayon',
          fontSize: 15,
          color: isLightTheme ? AppColors.white : AppColors.black,
        ),
        headline4: TextStyle(
          fontFamily: 'Bayon',
          fontSize: 30,
          color: isLightTheme ? AppColors.white : AppColors.black,
        ),
        headline5: TextStyle(
          fontFamily: 'OdorMeanChey',
          fontSize: 16,
          decoration: TextDecoration.underline,
          color: isLightTheme ? AppColors.black : AppColors.white,
        ),
        headline6: TextStyle(
            fontFamily: 'Battambang',
            fontSize: 15,
            color: isLightTheme ? AppColors.white : AppColors.black,
            decoration: TextDecoration.underline),
      ),
    );
  }

  ThemeMode themeMode() {
    return ThemeMode(
      gradientColors: isLightTheme
          ? [AppColors.cream, AppColors.choco]
          : [AppColors.dark1, AppColors.dark2],
      //? light : dark
      switchColor: isLightTheme ? AppColors.black : AppColors.white,
      thumbColor: isLightTheme ? AppColors.white : AppColors.black,
      switchBgColor: isLightTheme ? AppColors.choco2 : AppColors.cream,
      switchBgColor2: isLightTheme ? AppColors.cream : AppColors.choco2,
    );
  }
}

class ThemeMode {
  List<Color>? gradientColors;
  Color? switchColor;
  Color? thumbColor;
  Color? switchBgColor;
  Color? switchBgColor2;

  ThemeMode({
    this.gradientColors,
    this.switchColor,
    this.thumbColor,
    this.switchBgColor,
    this.switchBgColor2,
  });
}
