import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Models/UserModel.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/auth/reset_password_screen.dart';
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
      body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child:
              Column(
                children: [
                  // const Spacer(),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 300),
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.65,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                        ),
                        child: Column(
                          children: [
                            // const SizedBox(height: 40),
                            const Text("Login",
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 40),
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
                            const SizedBox(height: 10),
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              InkWell(
                                onTap: () => goToResetPassword(context),
                                child:
                                const Text("Forgot Password?", style: TextStyle(color: Colors.orange)),
                              )
                            ]),
                            const SizedBox(height: 10),
                            CustomButton(
                              label: "Login",
                              onPressed: _login,
                            ),
                            const SizedBox(height: 20),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Text("Don't have any account? "),
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
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        height: 250,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child:
                          Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child:SizedBox(
                              height: 300,
                              width: 250,
                              child: FadeInImage(
                                fit: BoxFit.contain,
                                placeholder: const NetworkImage("https://i.giphy.com/media/l2Jeev6AvurRQMgEM/200.gif"),
                                image: const NetworkImage("https://i.giphy.com/media/l2Jeev6AvurRQMgEM/200.gif"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  'assets/images/login.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]
      )

    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToResetPassword(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
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
