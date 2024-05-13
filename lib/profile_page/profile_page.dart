import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe2e9ff),
        title: const Text(
          'Profile',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
    );
  }
}
