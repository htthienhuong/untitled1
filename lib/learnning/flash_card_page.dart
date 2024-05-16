import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          )
        ],
        title: Text(
          '${currentItem + 1}/${widget.wordModels.length}',
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600),
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.25),
                    border: Border.all(color: Colors.orange.withOpacity(0.6)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(50))),
                child: Container(
                  width: 35,
                  height: 25,
                  alignment: Alignment.center,
                  child: Text(
                    '$forgotWord',
                    style: const TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.25),
                    border:
                        Border.all(color: Colors.greenAccent.withOpacity(0.6)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50))),
                child: Container(
                  width: 35,
                  height: 25,
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
                    print('memoriedWordIdList: $memoriedWordIdList');
                    // await ApiService.learningCount(memoriedWordIdList);s
                    for (String wordId in memoriedWordIdList) {
                      await WordService()
                          .updateWordLearnCount(wordId, AppData.userModel.id);
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.reply,
                size: 35,
                color: Colors.grey[400],
              ),
              const SizedBox(
                width: 20,
              ),
              const SizedBox(
                width: 200,
                child: Text(
                  'Click the Play icon to start surfing automatically',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 20,
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
                        size: 35,
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
                        timer =
                            Timer.periodic(const Duration(seconds: 3), (timer) {
                          if (currentItem < widget.wordModels.length - 1) {
                            Future.delayed(const Duration(seconds: 1), () {
                              if (mounted) {
                                print('flip $currentItem');
                                _flipCardControllerList[currentItem]
                                    .toggleCard();
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
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 35,
                        color: Colors.grey[600],
                      ),
                    )
            ],
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
      // fill: Fill
      //     .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      side: (isBack != null && isBack == true)
          ? CardSide.BACK
          : CardSide.FRONT, // The side to initially display.
      front: Container(
        child: _buildCardWord(wordModel.english!, index),
      ),
      back: _buildCardWord(wordModel.vietnam!, index),
    );
  }

  Widget _buildCardWord(String word, int index) {
    return Card(
      color: Colors.white,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          alignment: Alignment.center,
          child: Text(
            word,
            style: const TextStyle(fontSize: 30),
          )),
    );
  }
}
