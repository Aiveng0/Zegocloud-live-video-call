import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorHelper {
  static const Color background = Color(0xff202124);
  static const Color backgroundLite = Color(0xff28292c);
  static const Color grey = Color(0xff3c4043);
  static const Color red = Color(0xffea4335);

  static MaterialColor getRandomColor() {
    const List<MaterialColor> colors = [
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.deepPurple,
      Colors.deepOrange,
    ];

    final math.Random random = math.Random();
    final index = random.nextInt(colors.length);

    return colors[index];
  }
}

// 202124 background
// 28292c
// 3c4043 button
// ea4335 red