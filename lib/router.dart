import 'package:amazon_clone_app/features/auth/pages/auth_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AuthPage(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => Scaffold(
              body: Center(child: Text('Screen does not exist!')),
            ),
      );
  }
}
