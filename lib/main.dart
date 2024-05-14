import 'package:flutter/material.dart';
import 'package:untitled1/router/router_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      initialRoute: Routes.loginPage,
      onGenerateRoute: RouteGenerator.getRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
