import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/word_model.dart';
import 'multiple_choice_game.dart';

class LearningPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const LearningPage({super.key, required this.wordModels});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int currentItem = 0;
  final List<String> wordIdList = [];

  void shuffle(List array) {
    for (var i = array.length - 1; i > 0; i--) {
      var j = Random().nextInt(i + 1);
      var temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxAnswer = widget.wordModels.length < 4 ? widget.wordModels.length : 4;
    List<String> randomWordList = [];
    Random random = Random();
    randomWordList.add(widget.wordModels[currentItem].vietnam!);

    while (randomWordList.length != maxAnswer) {
      var rd = random.nextInt(widget.wordModels.length);
      if (!randomWordList.contains(widget.wordModels[rd].vietnam!)) {
        randomWordList.add(widget.wordModels[rd].vietnam!);
      }
    }
    shuffle(randomWordList);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learning Page',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800]),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[800],
            size: 30,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.grey[800],
              ))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          MultipleChoiceGame(
            currentWord: widget.wordModels[currentItem],
            answerList: randomWordList,
            handleOnOkClick: _addCurrentItem,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _addCurrentItem(bool result) async {
    if (result) {
      wordIdList.add(widget.wordModels[currentItem].id!);
    }
    print('currentItem: $currentItem');
    if (currentItem == widget.wordModels.length - 1) {
      print('wordIdList: $wordIdList');
      for (String wordId in wordIdList) {
        await WordService().updateWordLearnCount(wordId, AppData.userModel.id);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        currentItem++;
      });
    }
  }
}
