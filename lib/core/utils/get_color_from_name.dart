import 'package:flutter/material.dart';

Color getColorFromName(String name) {
  final colors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
  ];
  final hash = name.codeUnits.fold(0, (a, b) => a + b);
  return colors[hash % colors.length];
}
