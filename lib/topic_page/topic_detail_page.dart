import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/TopicModel.dart';
import '../Models/word_model.dart';
import '../router/router_manager.dart';
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
  List<WordModel> wordModelList = [];
  bool isBack = false;
  int size = 1;

  final pageController = PageController(viewportFraction: 0.85);
  final TextStyle listTileTextStyle = const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white);

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
      backgroundColor: const Color(0xffe2e9ff),
      appBar: AppBar(
          backgroundColor: const Color(0xffe2e9ff),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xff647ebb),
            ),
          ),
          title: Text(
            widget.topicModel.topicName!,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
          ),
          centerTitle: true,
          actions: [
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
                                    content:
                                        Text('Csv was exported to Download'),
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
                  icon: const Icon(
                    FontAwesomeIcons.fileExport,
                    color: Color(0xff647ebb),
                  )),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(),
      ),
    );
  }

  Future<void> _exportCsv() async {
    await [
      Permission.storage,
    ].request();

    List<dynamic> associateList = [];
    for (WordModel wordModel in wordModelList) {
      associateList
          .add({'English': wordModel.english, "Vietnamese": wordModel.vietnam});
    }

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("English");
    row.add("Vietnamese");
    rows.add(row);
    for (int i = 0; i < associateList.length; i++) {
      List<dynamic> row = [];
      row.add(associateList[i]["English"]);
      row.add(associateList[i]["Vietnamese"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    String file = "$dir";

    File f = File("$file/${widget.topicModel.topicName}.csv");

    f.writeAsString(csv);
  }

  Widget _buildBody() {
    return FutureBuilder(
        future:
            WordService().getWordListFromRef(widget.topicModel.wordReferences!),
        builder:
            (BuildContext context, AsyncSnapshot<List<WordModel>> snapshot) {
          if (snapshot.hasData) {
            wordModelList = snapshot.data!;
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
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Let's Study",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(
                    height: 8,
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
                                'Choose The Number To Learn',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              MySlider(
                                getSize: _getSize,
                                max: wordModelList.length.toDouble(),
                              ),
                              MySwitchWidget(getValue: _getSide),
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
                          ? const Color(0xffd0d4ec)
                          : const Color(0xff647ebb),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            'Flash Card',
                            style: listTileTextStyle,
                          ),
                          trailing: Image.asset('assets/images/flash_card.png',
                              height: 60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                                'Choose The Number To Learn',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              MySlider(
                                getSize: _getSize,
                                max: wordModelList.length.toDouble(),
                              ),
                            ],
                          ),
                          btnOkOnPress: () async {
                            await Navigator.pushNamed(
                                context, Routes.learningPage, arguments: [
                              _getRandomWordList(size),
                              widget.topicModel.id
                            ]);
                            setState(() {});
                          },
                          btnCancelOnPress: () {},
                        ).show();
                      }
                    },
                    child: Card(
                      color: wordModelList.isEmpty
                          ? const Color(0xffd0d4ec)
                          : const Color(0xff647ebb),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            'Multichoice Test',
                            style: listTileTextStyle,
                          ),
                          trailing: Image.asset('assets/images/learning.png',
                              height: 60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                                'Choose The Number To Learn',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              MySlider(
                                getSize: _getSize,
                                max: wordModelList.length.toDouble(),
                              ),
                            ],
                          ),
                          btnOkOnPress: () async {
                            await Navigator.pushNamed(
                              context,
                              Routes.typingPage,
                              arguments: _getRandomWordList(size),
                            );
                            setState(() {});
                          },
                          btnCancelOnPress: () {},
                        ).show();
                      }
                    },
                    child: Card(
                      color: wordModelList.isEmpty
                          ? const Color(0xffd0d4ec)
                          : const Color(0xff647ebb),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            'Typing',
                            style: listTileTextStyle,
                          ),
                          trailing: Image.asset('assets/images/typing_icon.png',
                              height: 60),
                        ),
                      ),
                    ),
                  ),
                  widget.topicModel.isPublic!
                      ? GestureDetector(
                          onTap: () {
                            if (wordModelList.isNotEmpty) {
                              Navigator.pushNamed(
                                  context, Routes.leaderBoardPage,
                                  arguments: widget.topicModel.id);
                            }
                          },
                          child: Card(
                            color: wordModelList.isEmpty
                                ? Colors.grey.withOpacity(0.3)
                                : null,
                            child: ListTile(
                              title: Text(
                                'Leading Board',
                                style: listTileTextStyle,
                              ),
                              leading: Image.asset(
                                  'assets/images/leading_board_icon.png',
                                  height: 20),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Total: ${widget.topicModel.wordReferences?.length ?? 0} words",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blueAccent),
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

  Widget _getWordProcess(double num) {
    if (num < 25) {
      return const Text(
        'Stranger',
        style: TextStyle(color: Colors.redAccent, fontSize: 16),
      );
    }
    if (num < 50) {
      return const Text(
        'A Bit Close',
        style: TextStyle(color: Colors.orange, fontSize: 16),
      );
    }
    return const Text(
      'My Friend',
      style: TextStyle(color: Colors.green, fontSize: 16),
    );
  }

  Widget _buildCardWords(WordModel wordModel) {
    return Card(
      color: const Color(0xffd0d4ec),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 85,
              child: FutureBuilder(
                future: WordService()
                    .getWordLearnCount(wordModel.id!, AppData.userModel.id),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    int count = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: _getWordProcess(
                            (count / 20) * 100,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        CircularPercentIndicator(
                          backgroundColor: Colors.white,
                          radius: 16.0,
                          lineWidth: 2.0,
                          percent: count < 20 ? (count / 20) : 1,
                          progressColor: Colors.green,
                        ),
                      ],
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${wordModel.english}',
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xff647ebb)),
                    ),
                  ],
                ),
                Text(
                  '${wordModel.vietnam}',
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xff647ebb)),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await speak(wordModel.english, true);
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
                ),
                FutureBuilder(
                  future: WordService()
                      .getWordStar(wordModel.id!, AppData.userModel.id),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      bool starred = snapshot.data!;
                      return IconButton(
                          onPressed: () async {
                            await WordService().updateWordStatus(
                                wordModel.id!, AppData.userModel.id, !starred);
                            setState(() {});
                          },
                          icon: starred
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              : const Icon(
                                  Icons.star_outline,
                                  color: Colors.white,
                                ));
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
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        color: const Color(0xffd0d4ec),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.volume_up,
                color: Color(0xff647ebb),
                size: 40,
              ),
              onPressed: () async {
                await speak(word, isEnglish);
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  word,
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                )),
          ],
        ),
      ),
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
          inactiveColor: const Color(0xffd0d4ec),
          activeColor: const Color(0xff647ebb),
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

class MySwitchWidget extends StatefulWidget {
  final Function getValue;
  const MySwitchWidget({super.key, required this.getValue});

  @override
  State<MySwitchWidget> createState() => _MySwitchWidgetState();
}

class _MySwitchWidgetState extends State<MySwitchWidget> {
  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text(selectedValue ? 'Back Side' : 'Front Side'),
          const SizedBox(
            width: 8,
          ),
          Switch(
            activeColor: Colors.blueAccent,
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                setState(() {
                  selectedValue = value;
                });
                widget.getValue(selectedValue);
              });
            },
          ),
        ],
      ),
    );
  }
}
