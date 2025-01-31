import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData get globalTheme => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      disabledColor: Colors.grey,
      colorScheme: const ColorScheme(
        // primary: Color(0xFF027939),
        // primaryContainer: Color(0xFF00461D),
        primary: Color(0xFF065C55),
        primaryContainer: Color(0xFF043633),
        secondary: Color(0xffa3a9cb),
        surface: Colors.white,
        error: Color(0xFFEB5757),
        onPrimary: Color(0xff356eff),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFF333852),
        onError: Color(0xFFFFFFFF),
        brightness: Brightness.light,
      ),
      cardTheme: const CardTheme(
        color: Color(0xfff5f6f8),
        elevation: 2,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0.0,
        selectedItemColor: Color(0xff356eff),
        unselectedItemColor: Color(0xffd5d9ea),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(
          color: Color(0xffa3a9cb),
          width: 2,
        ),
        fillColor: WidgetStateProperty.all(Colors.white),
        checkColor: WidgetStateProperty.all(
          const Color(0xff356eff),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 10.0,
        ),
        hintStyle: TextStyle(
          color: Color(0xFFCACBCF),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF043633),
        contentTextStyle: ThemeData().textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
      datePickerTheme: DatePickerThemeData(
        surfaceTintColor: Colors.white,
        dividerColor: Colors.transparent,
        headerBackgroundColor: const Color(0xFF065C55),
        headerForegroundColor: Colors.white,
        headerHelpStyle: const TextStyle(color: Colors.white),
        dayStyle: const TextStyle(color: Colors.white),
        weekdayStyle: const TextStyle(
          color: Color(0xFF065C55),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        todayForegroundColor: WidgetStateProperty.all(Colors.white),
        todayBackgroundColor: WidgetStateProperty.all(const Color(0xFF065C55)),
        dayBackgroundColor: WidgetStateProperty.all(const Color(0xB6FBFBFB)),
      ),
    );
