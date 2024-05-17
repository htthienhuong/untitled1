import 'package:flutter/material.dart';
import '../app_data/app_data.dart';

import '../Services/TopicServices.dart';
import '../Services/FolderService.dart';

import '../Models/TopicModel.dart';
import '../Models/Folder.dart';
class AddFolderDialog extends StatefulWidget {
  const AddFolderDialog({super.key});

  @override
  State<AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  String? folderId;

  TextEditingController _folderNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
      title: const Text(
        'Create New Folder',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
      ),
      content: Form(
        key: _formKey,
        child:
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300, minWidth: 500, minHeight: 300),
            child:       Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Folder',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),

                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _folderNameController,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Folder Name',
                      border: UnderlineInputBorder(),
                      hintStyle: TextStyle(height: 2, fontFamily: "Epilogue")
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    print('add folder done');
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                const Text(
                  'Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),

                const SizedBox(
                  height: 8,
                ),

                Expanded(
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Epilogue",
                    ),
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Description',
                        border: UnderlineInputBorder(),
                        hintStyle: TextStyle(height: 1.5, fontFamily: "Epilogue")
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (newValue) {
                      print('add folder done');
                    },
                  ),
                )
              ],
            )
        ),

      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('CREATE'),
          onPressed: () async{
            print(_folderNameController.text);
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              folderId = await FolderService().addFolderWithUserReference(
                  folder: Folder(
                    folderName: _folderNameController.text,
                    description: _descriptionController.text,
                    userId: AppData.userModel.id,
                  )
              );
              if(context.mounted){
                Navigator.pop(context);
              }

            }
          },
        ),
      ],
    );
  }
}
