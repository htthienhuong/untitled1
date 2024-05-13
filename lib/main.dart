import 'package:flutter/material.dart';
import 'package:untitled1/router/router_manager.dart';

void main() {
  runApp(
    const MaterialApp(
      initialRoute: Routes.mainPage,
      onGenerateRoute: RouteGenerator.getRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
