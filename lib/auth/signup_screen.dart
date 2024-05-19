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
            child: Column(
              children: [
                Stack(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(top: 300),
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        // const Spacer(),
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
                          width: 200,
                          child: FadeInImage(
                            fit: BoxFit.contain,
                            placeholder: const NetworkImage("https://i.giphy.com/media/9Dk2vkAmYs5dsSRu3B/200.gif"),
                            image: const NetworkImage("https://i.giphy.com/media/9Dk2vkAmYs5dsSRu3B/200.gif"),
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

                ])
              ],
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
