import 'package:flutter/painting.dart';

class ThemeColor{
  List<Color> gradient;
  Color backgroundColor;
  Color imageColor;
  Color cardTextColor;
  Color imageBackgroundColor;
  Color textColor;
  List<BoxShadow> shadow;

  ThemeColor({
    required this.gradient,
    required this.backgroundColor,
    required this.imageBackgroundColor,
    required this.imageColor,
    required this.cardTextColor,
    required this.textColor,
    required this.shadow,
});

}