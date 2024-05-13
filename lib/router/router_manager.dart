import 'package:flutter/material.dart';

import '../main_page/main_page.dart';

class Routes {
  static const String mainPage = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
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
