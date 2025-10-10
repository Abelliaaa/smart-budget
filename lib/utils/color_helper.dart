import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // tambahkan opacity
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
