import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/routes/app_routes.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}

/// add all functionality + riverpod if all are working then next step is firebase + send sms
/// Functionalities :-
/// in dashboard screen all containers functionality like chart,bar,pie, and many more
/// in view customer screen paid,unpaid,overdue, and upcoming functionality + search bar + filter(newest or oldest) aslo edit and delete customer
/// in report screen all containers functionality like chart,bar,pie, and many more
/// in setting screen dark and light theme, update user profile like name,image, and also notification section