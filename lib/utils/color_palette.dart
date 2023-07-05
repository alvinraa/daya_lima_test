import 'package:flutter/material.dart';

const MaterialColor myPrimaryColor =
    MaterialColor(_myPrimaryColorPrimaryValue, <int, Color>{
  50: Color(0xFFE3E9F3),
  100: Color(0xFFB9C9E1),
  200: Color(0xFF8BA5CD),
  300: Color(0xFF5C81B9),
  400: Color(0xFF3966AA),
  500: Color(_myPrimaryColorPrimaryValue),
  600: Color(0xFF134493),
  700: Color(0xFF103B89),
  800: Color(0xFF0C337F),
  900: Color(0xFF06236D),
});
const int _myPrimaryColorPrimaryValue = 0xFF164B9B;

const MaterialColor myPrimaryColorAccent =
    MaterialColor(_myPrimaryColorAccentValue, <int, Color>{
  100: Color(0xFF9DB3FF),
  200: Color(_myPrimaryColorAccentValue),
  400: Color(0xFF3764FF),
  700: Color(0xFF1E50FF),
});
const int _myPrimaryColorAccentValue = 0xFF6A8CFF;
