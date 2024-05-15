import 'package:flutter/material.dart';

import '../Models/TopicModel.dart';
import '../Services/TopicServices.dart';
import '../router/router_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  TextEditingController searchController = TextEditingController();
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
                Expanded(
                    child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                )),
                const VerticalDivider(
                  color: Colors.black,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        search = searchController.text;
                      });
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
          ),
          const Text(
            'Community',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: FutureBuilder(
                future: TopicService().searchPublicTopics(search),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                child: Text(
                  topicModel.topicName!,
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ]),
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

  final List<String> myCoolStrings = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Some other item'
  ];
  final List<String> _results = []; // Empty at start

  void _handleSearch(String input) {
    _results.clear();
    for (var str in myCoolStrings) {
      if (str.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _results.add(str);
        });
      }
    }
  }
}
