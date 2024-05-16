import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Services/TopicServices.dart';
import 'package:untitled1/folder_page/popup_dialog.dart';
import '../Services/FolderService.dart';
import 'package:untitled1/router/router_manager.dart';

import '../Models/TopicModel.dart';
import '../Models/Folder.dart';
import '../app_data/app_data.dart';

class FolderDetailPage extends StatefulWidget {
  final Folder folder;
  const FolderDetailPage({
    super.key,
    required this.folder,
  });

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  String? selectedItem;
  List<TopicModel> topicsNotInFolder = [];
  List<TopicModel> topicList = [];

  @override
  void initState() {
    _asyncmethodCall();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // topic = widget.folder.Topics!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Folder Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if(topicsNotInFolder.isNotEmpty){
                Navigator.pushNamed(context, Routes.folderAddTopicPage,
                arguments: [widget.folder, topicsNotInFolder]);
              }else{
                  await showDialog(
                  context: context,
                  builder: (_) => const PopupMessageDialog(message: "You've already added all of your topics to this folder"),
                  );
              };
              },
            icon: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
          widget.folder.folderName,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87),
        ),
        Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FadeInImage(
                  placeholder:
                  const AssetImage('assets/images/htth_avt.png'),
                  image: const NetworkImage('xxx'),
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/htth_avt.png'),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            // Text(
            //   widget.folder.userName!,
            //   style: const TextStyle(
            //       fontWeight: FontWeight.w500, color: Colors.black87),
            // ),
            const SizedBox(
              height: 20,
              child: VerticalDivider(
                thickness: 2,
                indent: 2,
                endIndent: 2,
              ),
            ),
            Text(
              '${widget.folder.Topics!.length} words',
              style: const TextStyle(
                  color: Colors.black38, fontWeight: FontWeight.w500),
            ),

            const SizedBox(
              height: 15,
            ),
            ],
        ),
            Expanded(
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.only(right: 8.0),
              //       child: MyDropdownButton(),
              //     ),
              //   ],
              // ),
              child: FutureBuilder(
                  future: FolderService().getTopicByFolderId(widget.folder.documentId!),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> topicModelList = snapshot.data!;
                      for (DocumentSnapshot documentSnapshot in topicModelList) {
                        TopicModel topic = TopicModel.fromFirestore(documentSnapshot);
                        topicList.add(topic);
                      }

                      print(topicList.length);
                      return ListView.builder(
                        itemCount: topicList.length,
                        itemBuilder: (context, index) {
                          return _buildTopicItem(context, topicList[index]);
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
    );
  }

  void _asyncmethodCall() async {
    topicsNotInFolder = await FolderService().getTopicsNotInFolderByFolderId(AppData.userModel.id, widget.folder.documentId);
  }

  Widget _buildTopicItem(BuildContext context, TopicModel topicModel) {
    print('selectedItem: $selectedItem');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.topicDetailPage,
            arguments: topicModel);
      },
      child: Container(
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
                  topicModel.topicName!,
                  style: const TextStyle(fontSize: 20),
                ),
                PopupMenuButton<String>(
                  color: const Color(0xffbcc1d0),
                  initialValue: selectedItem,
                  onSelected: (String item) {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      onTap: () async {
                        await Navigator.pushNamed(
                            context, Routes.updateTopicPage,
                            arguments: topicModel);
                        setState(() {});
                      },
                      value: 'Edit',
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.edit_note_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const PopupMenuDivider(
                      height: 1,
                    ),
                    PopupMenuItem<String>(
                      onTap: () async {
                        await TopicService().deleteTopicWithUserReference(
                            topicModel, AppData.userModel.id);
                        setState(() {});
                      },
                      value: 'Delete',
                      child: const Row(
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage(
                          placeholder:
                          const AssetImage('assets/images/htth_avt.png'),
                          image: NetworkImage(topicModel.userAvatarUrl ?? ''),
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/htth_avt.png'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(topicModel.userName!),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xffacbdd0),
                      borderRadius: BorderRadius.circular(8)),
                  child:
                  Text('${topicModel.wordReferences?.length ?? 0} words'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

