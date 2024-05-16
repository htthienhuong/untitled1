import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/word_model.dart';

class FlashCardPage extends StatefulWidget {
  final bool? isBack;
  final List<WordModel> wordModels;
  const FlashCardPage({super.key, required this.wordModels, this.isBack});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  late List<FlipCardController> _flipCardControllerList;

  Timer? timer;
  bool isAuto = false;

  int currentItem = 0;

  int forgotWord = 0;
  int memoriedNum = 0;
  List<String> memoriedWordIdList = [];
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    for (int i = 0; i < widget.wordModels.length; i++) {
      _swipeItems.add(
        SwipeItem(
          likeAction: () {
            memoriedNum++;
            memoriedWordIdList.add(widget.wordModels[currentItem].id!);
          },
          nopeAction: () {
            forgotWord++;
          },
          onSlideUpdate: (SlideRegion? region) async {},
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    _flipCardControllerList = List.generate(
        widget.wordModels.length, (index) => FlipCardController());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd0d4ec),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff647ebb),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(
          '${currentItem + 1}/${widget.wordModels.length}',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: Colors.orangeAccent.withOpacity(0.4),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '$forgotWord',
                    style: const TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.lightGreenAccent.withOpacity(0.4),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '$memoriedNum',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 3, color: Color(0xff647ebb))),
                  child: SwipeCards(
                    matchEngine: _matchEngine!,
                    likeTag: const Text(
                      'Memorized',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                    nopeTag: const Text(
                      'Not yet memorized',
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCardWordItem(
                          widget.wordModels[index], index, widget.isBack);
                    },
                    onStackFinished: () async {
                      for (String wordId in memoriedWordIdList) {
                        await WordService()
                            .updateWordLearnCount(wordId, AppData.userModel.id);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Stack Finished"),
                          duration: Duration(milliseconds: 500),
                        ));
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    itemChanged: (SwipeItem item, int index) {
                      setState(() {
                        currentItem = index;
                      });
                    },
                    leftSwipeAllowed: true,
                    rightSwipeAllowed: true,
                    upSwipeAllowed: true,
                    fillSpace: false,
                  ),
                ),
              ),
            ),
          ),
          isAuto
              ? IconButton(
                  onPressed: () {
                    timer?.cancel();

                    setState(() {
                      isAuto = !isAuto;
                    });
                  },
                  icon: const Icon(
                    Icons.pause,
                    size: 75,
                    color: Colors.white,
                  ))
              : IconButton(
                  onPressed: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        print('flip $currentItem');

                        _flipCardControllerList[currentItem].toggleCard();
                      }
                    });

                    setState(() {
                      isAuto = !isAuto;
                    });
                    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
                      if (currentItem < widget.wordModels.length - 1) {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            print('flip $currentItem');
                            _flipCardControllerList[currentItem].toggleCard();
                          }
                        });
                        _matchEngine!.currentItem!.like();
                        print('currentItem: $currentItem');
                      } else {
                        _matchEngine!.currentItem!.like();
                        timer.cancel();
                        setState(() {
                          isAuto = !isAuto;
                        });
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 75,
                    color: Colors.white,
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCardWordItem(WordModel wordModel, int index, [bool? isBack]) {
    return FlipCard(
      controller: _flipCardControllerList[index],
      direction: FlipDirection.HORIZONTAL,
      side: (isBack != null && isBack == true) ? CardSide.BACK : CardSide.FRONT,
      front: Container(
        child: _buildCardWord(wordModel.english!, index),
      ),
      back: _buildCardWord(wordModel.vietnam!, index),
    );
  }

  Widget _buildCardWord(String word, int index) {
    return Card(
      color: const Color(0xff647ebb),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          alignment: Alignment.center,
          child: Text(
            word,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          )),
    );
  }
}
