import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.only(right: 8.0),
          //       child: MyDropdownButton(),
          //     ),
          //   ],
          // ),
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
                        return _buildTopicItem(context, topicModelList[index]);
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.topicDetailPage,
            arguments: topicModel);
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
            SizedBox(
              height: 60,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      topicModel.topicName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xff1b2794),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  PopupMenuButton<String>(
                    iconColor: const Color(0xff1b2794),
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
                    Text(
                      topicModel.userName!,
                      style: const TextStyle(color: Color(0xff647ebb)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xffacbdd0),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    '${topicModel.wordReferences?.length ?? 0} words',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
//
// const List<String> list = <String>['Last access', 'Two', 'Three', 'Four'];
//
// class MyDropdownButton extends StatefulWidget {
//   const MyDropdownButton({super.key});
//
//   @override
//   State<MyDropdownButton> createState() => _MyDropdownButtonState();
// }
//
// class _MyDropdownButtonState extends State<MyDropdownButton> {
//   String dropdownValue = list.first;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 30,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8), color: Colors.grey),
//       child: DropdownButton<String>(
//         value: dropdownValue,
//         icon: const Icon(Icons.arrow_drop_down),
//         elevation: 16,
//         style: const TextStyle(color: Colors.black),
//         onChanged: (String? value) {
//           // This is called when the user selects an item.
//           setState(() {
//             dropdownValue = value!;
//           });
//         },
//         items: list.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
