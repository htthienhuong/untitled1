import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/TopicModel.dart';
import '../Models/word_model.dart';
import '../router/router_manager.dart';
import '../utilities/tts_uti.dart';

class StarredWordPage extends StatefulWidget {
  const StarredWordPage({
    super.key,
  });

  @override
  State<StarredWordPage> createState() => _StarredWordPageState();
}

class _StarredWordPageState extends State<StarredWordPage> {
  List<WordModel> wordModelList = [];
  bool isBack = false;
  int size = 1;

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
                          await _exportCsv();
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

  Future<void> _exportCsv() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<dynamic> associateList = [];
    for (WordModel wordModel in wordModelList) {
      associateList
          .add({'Word': wordModel.english, "Definition": wordModel.vietnam});
    }

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("Word");
    row.add("Definition");
    rows.add(row);
    for (int i = 0; i < associateList.length; i++) {
      List<dynamic> row = [];
      row.add(associateList[i]["Word"]);
      row.add(associateList[i]["Definition"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File("$file/${'My Starred Word'}.csv");

    f.writeAsString(csv);
  }

  Widget _buildBody() {
    return FutureBuilder(
        future: WordService().getWordStarList(AppData.userModel.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<WordModel>> snapshot) {
          if (snapshot.hasData) {
            wordModelList = snapshot.data!;
            print('wordModelList: $wordModelList');
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
                  const Text(
                    "My Starred List",
                    style: TextStyle(
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
                        AppData.userModel.name,
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
                        '${wordModelList.length} words',
                        style: const TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (wordModelList.isNotEmpty) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.info,
                          body: Column(
                            children: [
                              const Text(
                                'Setting for FlashCard',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Choose the number of words to learn'),
                              MySlider(
                                getSize: _getSize,
                                max: wordModelList.length.toDouble(),
                              ),
                              MyRBtn(getValue: _getSide),
                            ],
                          ),
                          btnOkOnPress: () async {
                            await Navigator.pushNamed(
                                context, Routes.flashCardPage,
                                arguments: [
                                  _getRandomWordList(
                                    size,
                                  ),
                                  isBack
                                ]);
                            setState(() {});
                          },
                          btnCancelOnPress: () {},
                        ).show();
                      }
                    },
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
                      if (wordModelList.isNotEmpty) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.info,
                          body: Column(
                            children: [
                              const Text(
                                'Setting for Learning',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Choose the number of words to learn'),
                              MySlider(
                                getSize: _getSize,
                                max: wordModelList.length.toDouble(),
                              ),
                            ],
                          ),
                          btnOkOnPress: () async {
                            await Navigator.pushNamed(
                                context, Routes.learningPage,
                                arguments: _getRandomWordList(size));
                            setState(() {});
                          },
                          btnCancelOnPress: () {},
                        ).show();
                      }
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

  List<WordModel> _getRandomWordList(int size) {
    List<WordModel> randomWordList = [];
    Random random = Random();
    int maxAnswer = wordModelList.length < size ? wordModelList.length : size;

    while (randomWordList.length != maxAnswer) {
      bool isExist = false;
      print('randomWordList.length: ${randomWordList.length}');
      var rd = random.nextInt(wordModelList.length);
      for (int i = 0; i < randomWordList.length; i++) {
        if (randomWordList[i].id == wordModelList[rd].id) {
          isExist = true;
          break;
        }
      }
      if (!isExist) {
        randomWordList.add(wordModelList[rd]);
      }
    }
    return randomWordList;
  }

  void _getSide(bool value) {
    isBack = value;
  }

  void _getSize(int value) {
    size = value;
  }

  Widget _getStatus(double num) {
    if (num < 25) {
      return Text(
        'Not learned',
        style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
      );
    }
    if (num < 75) {
      return Text(
        'Learned',
        style: TextStyle(color: Colors.orange, fontSize: 12),
      );
    }
    return Text(
      'Memorized',
      style: TextStyle(color: Colors.green, fontSize: 12),
    );
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
                            FutureBuilder(
                              future: WordService().getWordStar(
                                  wordModel.id!, AppData.userModel.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  bool starred = snapshot.data!;
                                  return IconButton(
                                      onPressed: () async {
                                        await WordService().updateWordStatus(
                                            wordModel.id!,
                                            AppData.userModel.id,
                                            !starred);
                                        setState(() {});
                                      },
                                      icon: starred
                                          ? const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            )
                                          : const Icon(Icons.star_outline));
                                } else if (snapshot.hasError) {
                                  return const Text('error');
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
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
          Align(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: WordService()
                  .getWordLearnCount(wordModel.id!, AppData.userModel.id),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!;
                  return CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 2.0,
                    percent: count < 20 ? (count / 20) : 1,
                    center: _getStatus(
                      (count / 20) * 100,
                    ),
                    progressColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return const Text('error');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
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
    print("mywordModel: ${wordModel.english}");
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

class MySlider extends StatefulWidget {
  final Function getSize;
  final double max;

  const MySlider({super.key, required this.max, required this.getSize});

  @override
  State<MySlider> createState() => MySliderState();
}

class MySliderState extends State<MySlider> {
  double currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text(
            '${currentSliderValue.toInt()}/${widget.max.toInt()}',
          ),
        ),
        Slider(
          value: currentSliderValue,
          max: widget.max,
          divisions: widget.max.toInt(),
          label: currentSliderValue.round().toString(),
          onChanged: (double value) {
            if (value < 1) {
              currentSliderValue = 1;
            } else {
              setState(() {
                currentSliderValue = value;
                widget.getSize(value.toInt());
              });
            }
          },
        ),
      ],
    );
  }
}

class MyRBtn extends StatefulWidget {
  final Function getValue;
  const MyRBtn({super.key, required this.getValue});

  @override
  State<MyRBtn> createState() => _MyRBtnState();
}

class _MyRBtnState extends State<MyRBtn> {
  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('FRONT'),
          value: false,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
            widget.getValue(selectedValue);
          },
        ),
        RadioListTile(
          title: const Text('BACK'),
          value: true,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
            widget.getValue(selectedValue);
          },
        ),
      ],
    );
  }
}
