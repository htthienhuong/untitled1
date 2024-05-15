import 'package:flutter/material.dart';
import '../app_data/app_data.dart';

import '../Services/TopicServices.dart';
import '../Services/FolderService.dart';

import '../Models/TopicModel.dart';
import '../Models/Folder.dart';


class AddTopicToFolderPage extends StatefulWidget {
  const AddTopicToFolderPage({super.key});

  @override
  State<AddTopicToFolderPage> createState() => _AddTopicToFolderPageState();
}

class _AddTopicToFolderPageState extends State<AddTopicToFolderPage> {
  final _formKey = GlobalKey<FormState>();
  String? folderId;

  TextEditingController _folderNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

      ),
    );
  }
}
