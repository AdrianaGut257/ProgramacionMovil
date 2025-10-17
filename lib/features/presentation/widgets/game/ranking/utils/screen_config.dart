import 'package:flutter/material.dart';

class ScreenConfig {
  final Size size;
  final double horizontalPadding;
  final double titleFontSize;
  final double itemSpacing;

  ScreenConfig(this.size)
      : horizontalPadding = size.width * 0.06,
        titleFontSize = size.width * 0.07,
        itemSpacing = size.height * 0.015;

  double calculatePodiumHeight(String position) {
    switch (position) {
      case '1':
        return size.height * 0.15;
      case '2':
        return size.height * 0.12;
      case '3':
      default:
        return size.height * 0.10;
    }
  }
}
