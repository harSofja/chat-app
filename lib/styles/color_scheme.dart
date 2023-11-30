import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF164863);
const Color secondaryColor = Color(0xFF427D9D);
const Color lightColor = Color(0xFF9BBEC8);
const Color backgroundColor = Color(0xFFDDF2FD);

const ColorScheme colorScheme = ColorScheme(
  primary: primaryColor,
  secondary: secondaryColor,
  secondaryContainer: secondaryColor, // Adjust if you have a variant
  surface: lightColor,
  background: backgroundColor,
  error: Colors.red, // Define an error color if needed
  onPrimary: lightColor, // Text color on primary color
  onSecondary: Colors.white, // Text color on secondary color
  onSurface: lightColor, // Text color on surface color
  onBackground: lightColor, // Text color on background color
  onError: Colors.white, // Text color on error color
  brightness: Brightness.light,
);
