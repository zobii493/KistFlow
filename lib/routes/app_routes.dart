import 'package:flutter/material.dart';
import 'package:kistflow/views/auth/forgot_password_screen.dart';
import 'package:kistflow/views/auth/login_screen.dart';
import 'package:kistflow/views/auth/signup_screen.dart';
import 'package:kistflow/widgets/custom_widgets/custom_nav_bar_screen.dart';
import 'package:kistflow/views/screens/customer/view_customer_screen.dart';
import 'package:kistflow/views/splash/splash_screen.dart';
import '../models/customer.dart';
import '../views/screens/dashboard/dashboard_screen.dart';
import '../views/screens/dashboard/notification_screen.dart';
import '../views/screens/customer/payment_reminder_screen.dart';
import '../views/screens/settings/setting_screen.dart';
import '../views/screens/settings/change_password_screen.dart';
import '../views/screens/settings/delete_account_screen.dart';
import '../views/screens/settings/help_screen.dart';
import '../views/screens/settings/privacy_policy_screen.dart';
import '../views/screens/settings/terms_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotpassword = '/forgotpassword';
  static const String home = '/home';
  static const String bottomnavbar = '/bottomnavbar';
  static const String viewcustomer = '/viewcustomer';
  static const String settingscreen = '/settings';
  static const String help = '/help';
  static const String privacy = '/privacy';
  static const String term = '/terms';
  static const String notifications = '/notifications';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    forgotpassword: (context) => ForgotPasswordScreen(),
    home: (context) => DashboardScreen(),
    bottomnavbar: (context) => CustomNavBarScreen(),
    viewcustomer: (context) => ViewCustomerScreen(),
    settingscreen: (context) => const SettingsScreen(),

    // About Section Pages (ye 3 new pages hain)
    help: (context) => const HelpPage(),
    privacy: (context) => const PrivacyPolicyPage(),
    term : (context) => const TermsAndConditionsPage(),
    notifications: (context) => const NotificationScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    deleteAccount: (context) => const DeleteAccountScreen(),
  };
}
