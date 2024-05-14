import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/Services/WordServices.dart';

import '../Models/TopicModel.dart';
import '../Models/word_model.dart';
import '../utilities/tts_uti.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicModel topicModel;
  const TopicDetailPage({
    super.key,
    required this.topicModel,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final pageController = PageController(viewportFraction: 0.85);
  final TextStyle listTileTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you want export csv file'),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Yes'),
                        onPressed: () async {
                          // await _exportCsv();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Csv was exported to Download'),
                              ),
                            );

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.share)),
        ),
      ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
        future:
            WordService().getWordListFromRef(widget.topicModel.wordReferences!),
        builder:
            (BuildContext context, AsyncSnapshot<List<WordModel>> snapshot) {
          if (snapshot.hasData) {
            List<WordModel> wordModelList = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: pageController,
                      itemBuilder: (context, index) =>
                          MyCardWord(wordModel: wordModelList[index]),
                      itemCount: wordModelList.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Text(
                    widget.topicModel.topicName!,
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
                      Text(
                        widget.topicModel.userName!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black87),
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
                        '${widget.topicModel.wordReferences!.length} words',
                        style: const TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Card(
                      color: wordModelList.isEmpty
                          ? Colors.grey.withOpacity(0.3)
                          : null,
                      child: ListTile(
                        title: Text(
                          'Flash Card',
                          style: listTileTextStyle,
                        ),
                        leading: Image.asset('assets/images/flash_card.png',
                            height: 20),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (wordModelList.isNotEmpty) {}
                    },
                    child: Card(
                      color: wordModelList.isEmpty
                          ? Colors.grey.withOpacity(0.3)
                          : null,
                      child: ListTile(
                        title: Text(
                          'Learning',
                          style: listTileTextStyle,
                        ),
                        leading: Image.asset('assets/images/learning.png',
                            height: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wordModelList.length,
                    itemBuilder: (context, index) {
                      return _buildCardWords(wordModelList[index]);
                    },
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return const Text('error');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildCardWords(WordModel wordModel) {
    return SizedBox(
      height: 115,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${wordModel.english}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await speak(wordModel.english, true);
                              },
                              icon: const Icon(Icons.volume_up),
                            ),
                            IconButton(
                                onPressed: () async {
                                  // await ApiService.unMarking([wordModel.id!]);
                                  // setState(() {
                                  //   wordModel.marked = false;
                                  //   reset = true;
                                  // });
                                },
                                icon: const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ))
                          ],
                        )
                      ],
                    ),
                    Text(
                      '${wordModel.vietnam}',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCardWord extends StatefulWidget {
  final WordModel wordModel;
  const MyCardWord({super.key, required this.wordModel});

  @override
  State<MyCardWord> createState() => _MyCardWordState();
}

class _MyCardWordState extends State<MyCardWord> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return _buildCardWordItem(widget.wordModel);
  }

  Widget _buildCardWordItem(WordModel wordModel) {
    return FlipCard(
      // fill: Fill
      //     .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      onFlip: () {
        setState(() {
          isEnglish = !isEnglish;
        });
        print('isEnglish: $isEnglish');
      },
      side: CardSide.FRONT, // The side to initially display.
      front: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: _buildCardWord(wordModel.english!, isEnglish),
      ),
      back: _buildCardWord(wordModel.vietnam!, isEnglish),
    );
  }

  Widget _buildCardWord(String word, bool isEnglish) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Card(
            color: Colors.white,
            child: Container(alignment: Alignment.center, child: Text(word)),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(
                Icons.zoom_out_map,
                color: Colors.grey,
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(
                Icons.volume_up,
                color: Colors.grey,
                size: 25,
              ),
              onPressed: () async {
                await speak(word, isEnglish);
              },
            ),
          ),
        ),
      ],
    );
  }
}
