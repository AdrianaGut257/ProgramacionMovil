import 'package:flutter/material.dart';

const Color activeButtonColor = Color(0xFF1EA58A);
const Color inactiveButtonColor = Color(0xFF28D4B1);

ButtonStyle categoryButtonStyle({required bool isActive}) {
  return ElevatedButton.styleFrom(
    backgroundColor: isActive ? activeButtonColor : inactiveButtonColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    elevation: isActive ? 5 : 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
