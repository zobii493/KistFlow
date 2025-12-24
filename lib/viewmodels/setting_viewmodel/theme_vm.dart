import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends StateNotifier<ThemeMode> {
  ThemeViewModel() : super(ThemeMode.light) {
    // 🔥 App start hote hi saved theme load karo
    loadSavedTheme();
  }

  // Saved theme ko load karo
  Future<void> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('theme') ?? 'light';
      state = _stringToThemeMode(savedTheme);
    } catch (e) {
      print('Error loading theme: $e');
      state = ThemeMode.light; // fallback to light if error
    }
  }

  // Theme change aur save karo (String parameter accept karta hai settings screen ke liye)
  Future<void> setTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', theme);
      state = _stringToThemeMode(theme);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  // String ko ThemeMode mein convert karo
  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }
}

final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, ThemeMode>((ref) {
  return ThemeViewModel();
});