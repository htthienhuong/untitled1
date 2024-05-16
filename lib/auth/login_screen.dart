import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Models/UserModel.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/main_page/main_page.dart';
import 'package:untitled1/router/router_manager.dart';

import '../app_data/app_data.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final SharedPreferences prefs;

  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      if (userId != null) {
        log("User Logged In");
        AppData.userModel = (await UserService().getUserById(userId))!;
        if (mounted) {
          goToHome(context);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Login",
              onPressed: _login,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () => goToSignup(context),
                child:
                    const Text("Signup", style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToHome(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routes.mainPage);

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      AppData.userModel = (await UserService().getUserById(user.uid))!;
      await prefs.setString('userId', user.uid);

      if (mounted) {
        goToHome(context);
      }
    }
  }
}
