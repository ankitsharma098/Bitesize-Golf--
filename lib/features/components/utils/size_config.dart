import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  static double scaleWidth(double inputWidth) =>
      (inputWidth / 375.0) * screenWidth;

  static double scaleHeight(double inputHeight) =>
      (inputHeight / 812.0) * screenHeight;

  /// Scales font size relative to screen width (or textScaleFactor if you want accessibility respect)
  static double scaleText(double fontSize) =>
      (fontSize / 375.0) * screenWidth / textScaleFactor;
}
