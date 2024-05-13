import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        title: const Text(
          'Topic',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
    );
  }
}
