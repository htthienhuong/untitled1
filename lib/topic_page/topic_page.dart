import 'package:flutter/material.dart';
import 'package:untitled1/Services/TopicServices.dart';
import 'package:untitled1/router/router_manager.dart';

import '../Models/TopicModel.dart';
import '../app_data/app_data.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: [
                const Expanded(child: TextField()),
                const VerticalDivider(
                  color: Colors.black,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: MyDropdownButton(),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: TopicService().getTopicsByUserId(AppData.userModel.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TopicModel>> snapshot) {
                  if (snapshot.hasData) {
                    List<TopicModel> topicModelList = snapshot.data!;
                    print(topicModelList.length);
                    return ListView.builder(
                      itemCount: topicModelList.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await TopicService().deleteTopicWithUserReference(
                                  topicModelList[index].id!,
                                  AppData.userModel.id);
                              topicModelList.removeAt(index);
                            },
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "Are you sure you wish to delete this word?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          "DELETE",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text(
                                          "CANCEL",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 40.0),
                                child: Icon(
                                  Icons.delete,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            key: UniqueKey(),
                            child: _buildTopicItem(
                                context, topicModelList[index]));
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
    );
  }

  Widget _buildTopicItem(BuildContext context, TopicModel topicModel) {
    print('selectedItem: $selectedItem');
    return Container(
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
                topicModel.topicName,
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
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Row(
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
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Row(
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
                        image: const NetworkImage('xxx'),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/htth_avt.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text('Thien Huong'),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xffacbdd0),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('${topicModel.wordReferences?.length ?? 0} words'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

const List<String> list = <String>['Last access', 'Two', 'Three', 'Four'];

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.grey),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
