import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe2e9ff),
        title: const Text(
          'Home',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
    );
  }
}
