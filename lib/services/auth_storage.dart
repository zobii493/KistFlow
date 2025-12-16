import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static Future<void> saveCredentials(String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } else {
      await prefs.setBool('rememberMe', false);
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  static Future<Map<String, dynamic>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('rememberMe') ?? false;
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';
    return {
      "rememberMe": remember,
      "email": email,
      "password": password,
    };
  }
}
