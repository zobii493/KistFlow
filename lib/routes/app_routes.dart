import 'package:flutter/material.dart';
import 'package:kistflow/views/auth/forgot_password_screen.dart';
import 'package:kistflow/views/auth/login_screen.dart';
import 'package:kistflow/views/auth/signup_screen.dart';
import 'package:kistflow/views/screens/custom_nav_bar_screen.dart';
import 'package:kistflow/views/screens/view_customer_screen.dart';
import 'package:kistflow/views/splash/splash_screen.dart';
import '../models/customer.dart';
import '../views/screens/dashboard_screen.dart';
import '../views/screens/payment_reminder_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotpassword = '/forgotpassword';
  static const String home = '/home';
  static const String bottomnavbar = '/bottomnavbar';
  static const String viewcustomer = '/viewcustomer';
  // static const String paymentreminder = '/paymentreminder';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    forgotpassword: (context) => ForgotPasswordScreen(),
    home: (context) => DashboardScreen(),
    bottomnavbar: (context) => CustomNavBarScreen(),
    viewcustomer: (context) => ViewCustomerScreen(),
    // paymentreminder: (context) => PaymentReminderScreen(customer: customer,),
  };
}
