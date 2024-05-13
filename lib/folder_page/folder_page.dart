import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe2e9ff),
        title: const Text(
          'Folder',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
    );
  }
}
