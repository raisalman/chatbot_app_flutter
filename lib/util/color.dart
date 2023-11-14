import 'dart:ui';

import 'package:flutter/material.dart';

// const primaryColor= Color.fromRGBO(4,29,77,1);
const bgColor= Color.fromRGBO(246, 244, 244, 1.0);
const MaterialColor primaryColor = MaterialColor(_primaryColorPrimaryValue, <int, Color>{
  50: Color(0xFFE1E4EA),
  100: Color(0xFFB4BBCA),
  200: Color(0xFF828EA6),
  300: Color(0xFF4F6182),
  400: Color(0xFF2A3F68),
  500: Color(_primaryColorPrimaryValue),
  600: Color(0xFF031A46),
  700: Color(0xFF03153D),
  800: Color(0xFF021134),
  900: Color(0xFF010A25),
});
const int _primaryColorPrimaryValue = 0xFF041D4D;

 const MaterialColor primaryColorAccent = MaterialColor(_primaryColorAccentValue, <int, Color>{
  100: Color(0xFF6075FF),
  200: Color(_primaryColorAccentValue),
  400: Color(0xFF0020F9),
  700: Color(0xFF001DE0),
});
 const int _primaryColorAccentValue = 0xFF2D48FF;
// const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
//   50: Color(0xFFFFFFFF),
//   100: Color(0xFFFFFFFF),
//   200: Color(0xFFFFFFFF),
//   300: Color(0xFFFFFFFF),
//   400: Color(0xFFFFFFFF),
//   500: Color(_primaryPrimaryValue),
//   600: Color(0xFFFFFFFF),
//   700: Color(0xFFFFFFFF),
//   800: Color(0xFFFFFFFF),
//   900: Color(0xFFFFFFFF),
// });
// const int _primaryPrimaryValue = 0xFFFFFFFF;
//
//  const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
//   100: Color(0xFFFFFFFF),
//   200: Color(_primaryAccentValue),
//   400: Color(0xFFFFFFFF),
//   700: Color(0xFFFFFFFF),
// });
// const int _primaryAccentValue = 0xFFFFFFFF;