import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/app_data/app_data.dart';
import 'package:untitled1/main_page/main_page.dart';

import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  const Text("Signup",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    hint: "Enter Name",
                    label: "Name",
                    controller: _name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Email",
                    label: "Email",
                    controller: _email,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Password",
                    label: "Password",
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    label: "Signup",
                    onPressed: _signup,
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () => goToLogin(context),
                      child: const Text("Login", style: TextStyle(color: Colors.red)),
                    )
                  ]),
                  const Spacer()
                ],
              ),
            ),
          )
        ]
      )
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );

  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Succesfully");
      await UserService().createUser(user, _name.text);
      AppData.userModel = (await UserService().getUserById(user.uid))!;
      if (mounted) {
        goToHome(context);
      }
    }
  }
}
