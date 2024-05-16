import 'package:flutter/material.dart';
import '../Services/FolderService.dart';
import 'package:untitled1/router/router_manager.dart';

import '../Models/TopicModel.dart';
import '../Models/Folder.dart';
import '../app_data/app_data.dart';
class FolderListDialog extends StatefulWidget {
  final TopicModel topic;
  const FolderListDialog({
        super.key,
        required this.topic,
      });

  @override
  State<FolderListDialog> createState() => _FolderListDialogState();
}

class _FolderListDialogState extends State<FolderListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Choose Folder",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Epilogue"),
      ),
      content:
      ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 300, minWidth: 500, minHeight: 100),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: FolderService().getAllFoldersOfUser(AppData.userModel.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Folder>> snapshot) {
                    if (snapshot.hasData) {
                      List<Folder> folderList = snapshot.data!;
                      print(folderList.length);
                      return ListView.builder(
                        itemCount: folderList.length,
                        itemBuilder: (context, index) {
                          return _buildFolderItem(context, folderList[index]);
                        },
                      );
                    } else if (snapshot.hasData) {
                      return const Text('Error');
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ],
    );
  }

  Widget _buildFolderItem(BuildContext context, Folder folder) {
    return GestureDetector(
      onTap: () async{
        await FolderService().addTopicToFolderByTopicId(folder.documentId, widget.topic.id);

        if (context.mounted) {
          Navigator.pushNamed(context, Routes.mainPage).then((_) => setState(() {}));
        }
      },
      child:
      Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffdce1ef),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  folder.folderName,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Text(folder.description!),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xffacbdd0),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${folder.Topics?.length ?? 0} topics'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
