import 'package:amazon_clone_app/features/auth/pages/auth_page.dart';
import 'package:amazon_clone_app/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AuthPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomePage(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => Scaffold(
              body: Center(child: Text('Page does not exist!')),
            ),
      );
  }
}
