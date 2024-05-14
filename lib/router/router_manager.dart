import 'package:flutter/material.dart';
import 'package:untitled1/auth/login_screen.dart';
import 'package:untitled1/topic_page/add_topic_page.dart';

import '../main_page/main_page.dart';

class Routes {
  static const String mainPage = "/mainPage";
  static const String addTopicPage = "/addTopicPage";
  static const String loginPage = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.addTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => const AddTopicPage());
      case Routes.loginPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const LoginScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No route found'),
              ),
              body: const Center(
                  child: Text(
                'No route found',
                style: TextStyle(color: Colors.white),
              )),
            ));
  }
}
