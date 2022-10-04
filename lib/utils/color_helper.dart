import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorHelper {
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
