import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Color getColorFromSettings(String colorKey) {
  switch (colorKey) {
    case 'Green':
      return Colors.green.shade800;
    case 'Blue':
      return Colors.blue.shade900;
    case 'Red':
      return Colors.red.shade900;
    case 'Purple':
      return const Color.fromRGBO(45, 31, 242, 1.0);

    default:
      return Colors.black;
  }
}

int getSortOptions(String sorting, int index, Box noteBox) {
  int reversedIndex = noteBox.length - 1 - index;
  switch (sorting) {
    case 'Newest':
      return reversedIndex;
    case 'Oldest':
      return index;

    default:
      index;
  }
  return reversedIndex;
}

double getFontSize(String scale) {
  switch (scale) {
    case 'Small':
      return 0.8;
    case 'Medium':
      return 1;
    case 'Large':
      return 1.2;

    default:
      return 1;
  }
}
