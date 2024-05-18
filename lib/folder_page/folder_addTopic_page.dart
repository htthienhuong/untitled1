import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/Services/TopicServices.dart';
import '../Services/FolderService.dart';
import 'package:untitled1/router/router_manager.dart';

import '../Models/TopicModel.dart';
import '../Models/Folder.dart';
import '../app_data/app_data.dart';

class AddTopicToFolderPage extends StatefulWidget {
  final List<dynamic> arguments;
  const AddTopicToFolderPage({
    super.key,
    required this.arguments,
  });

  @override
  State<AddTopicToFolderPage> createState() => _AddTopicToFolderPageState();
}

class _AddTopicToFolderPageState extends State<AddTopicToFolderPage> {
  Folder? folder;
  List<TopicModel> topics = [];

  String? folderId;
  late List<String> selectedTopic = [];
  List<TopicModel> topicList = [];

  @override
  void initState() {
    folder = widget.arguments[0] as Folder;
    topics = widget.arguments[1] as List<TopicModel>;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add Topic To Folder",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                for (String addedTopicId in selectedTopic) {
                  if (folder != null) {
                    await FolderService().addTopicToFolderByTopicId(
                        folder?.documentId, addedTopicId);
                  }
                }
                if (context.mounted) {
                  Navigator.pushNamed(context, Routes.mainPage)
                      .then((_) => setState(() {}));
                }
              },
              icon: const Icon(
                Icons.check,
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
                Expanded(
                  child: _buildListView(context),
                )
              ],
            )));
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(children: [
                Expanded(
                    child: CheckboxMenuButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffdce1ef)),
                      fixedSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width, 100))),
                  value: selectedTopic.contains(topics[index].id),
                  onChanged: (value) {
                    setState(() {
                      print(value);
                      if (value != null) {
                        if (value) {
                          print("added");
                          selectedTopic.add(topics[index].id!);
                        } else {
                          print("removed");
                          selectedTopic.remove(topics[index].id!);
                        }
                      }
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            topics[index].topicName!,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Color(0xff1b2794),
                                fontWeight: FontWeight.w500),
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
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        'assets/images/htth_avt.png'),
                                    image: NetworkImage(
                                        topics[index].userAvatarUrl ?? ''),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                                'assets/images/htth_avt.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(topics[index].userName!),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              thickness: 2,
                              indent: 2,
                              endIndent: 2,
                            ),
                          ),
                          Text(
                            '${topics[index].wordReferences?.length ?? 0} words',
                            style: const TextStyle(
                                color: Colors.black38, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ]),
              const SizedBox(
                height: 15,
              )
            ],
          );
        });
  }
}
