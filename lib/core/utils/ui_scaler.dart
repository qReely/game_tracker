import 'dart:math';
import 'package:flutter/material.dart';

class UiScaler {
  static const Size designSize = Size(375, 812);
  
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _scaleWidth;
  static late double _scaleHeight;


  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    _scaleWidth = _screenWidth / designSize.width;
    _scaleHeight = _screenHeight / designSize.height;
  }

  static double setWidth(num width) => width * _scaleWidth;
  static double setHeight(num height) => height * _scaleHeight;
  static double setRadius(num r) => r * min(_scaleWidth, _scaleHeight);
  
  static double setSp(num fontSize) {
    // Prevent font from scaling too aggressively on huge screens (like tablets/web)
    // We cap the text scale factor impact to avoid layout breaking
    final scale = min(_scaleWidth, _scaleHeight);
    return fontSize * scale;
  }
}

extension UiScalerExtension on num {
  double get w => UiScaler.setWidth(this);
  double get h => UiScaler.setHeight(this);
  double get r => UiScaler.setRadius(this);
  double get sp => UiScaler.setSp(this);
}
