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

  TextEditingController _folderNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _folderNameController.text = widget.folder.folderName;
    _descriptionController.text = widget.folder.description!;

    return
      AlertDialog(
        title: Text(
          'Edit Folder',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
        ),
        content: Form(
          key: _formKey,
          child:
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500, maxHeight: 300, minWidth: 500, minHeight: 100),
              child:       Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Folder',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _folderNameController,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Folder Name',
                        border: UnderlineInputBorder(),
                        hintStyle: TextStyle(height: 2.5, fontFamily: "Epilogue")
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
                    height: 10,
                  ),

                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(
                    height: 12,
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
                          hintStyle: TextStyle(height: 2.5, fontFamily: "Epilogue")
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
            child: Text('UPDATE'),
            onPressed: () async{
              print(_folderNameController.text);
              if (_formKey.currentState!.validate()) {
                await FolderService().updateFolder(widget.folder.documentId!,
                    {'folderName': widget.folder.folderName, "description": widget.folder.description},);
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
