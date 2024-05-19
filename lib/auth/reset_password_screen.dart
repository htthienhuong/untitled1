import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Models/UserModel.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/auth/login_screen.dart';
import 'package:untitled1/main_page/main_page.dart';
import 'package:untitled1/router/router_manager.dart';

import '../app_data/app_data.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final SharedPreferences prefs;

  final _auth = AuthService();

  final _email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
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
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height * 0.5,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        children: [
                          // const SizedBox(height: 40),
                          const Text("Enter your email for reset password link",
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 40),
                          CustomTextField(
                            hint: "Enter Email",
                            label: "Email",
                            controller: _email,
                          ),
                          const SizedBox(height: 50),
                          CustomButton(
                            label: "Reset Password",
                            onPressed: () =>  resetPassword(context),
                          ),
                          const SizedBox(height: 20),
                          const Spacer()
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ]
        )

    );
  }

  Future<void> resetPassword(BuildContext context) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text.trim());
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: const Text(
            "Password reset link has been sent to your email",
            style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
            ),
          ],
        );
      });

    }
    on FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: const Text(
            "Your email wasn't registered",
          style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => setState(() {}),
              ),
          ],
        );
      });
    }
  }
}
