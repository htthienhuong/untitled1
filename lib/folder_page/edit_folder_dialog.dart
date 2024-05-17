import 'package:flutter/material.dart';
import '../app_data/app_data.dart';

import '../Services/FolderService.dart';

import '../Models/Folder.dart';
class EditFolderDialog extends StatefulWidget {
  final Folder folder;
  const EditFolderDialog({
    super.key,
    required this.folder,
  });

  @override
  State<EditFolderDialog> createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<EditFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  String? folderId;

  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _folderNameController.text = widget.folder.folderName;
    _descriptionController.text = widget.folder.description!;

    return
      AlertDialog(
        title: const Text(
          'Edit Folder',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
        ),
        content: Form(
          key: _formKey,
          child:
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300, minWidth: 500, minHeight: 100),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
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
                      print('edit folder done');
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
                        print('update folder done');
                      },
                    ),
                  )
                ],
              )
          ),

        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('UPDATE'),
            onPressed: () async{
              print(_folderNameController.text);
              if (_formKey.currentState!.validate()) {
                await FolderService().updateFolder(widget.folder.documentId!,
                    {'folderName': _folderNameController.text, "description": _descriptionController.text},);
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
