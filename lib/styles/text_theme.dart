import 'package:flutter/material.dart';

TextTheme customTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Roboto', // Replace with your font's name
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    // Add other styles as needed
  );
}
