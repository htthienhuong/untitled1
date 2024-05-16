import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/word_model.dart';
import 'typing_game.dart';

class TypingTestPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const TypingTestPage({super.key, required this.wordModels});

  @override
  State<TypingTestPage> createState() => _TypingTestPageState();
}

class _TypingTestPageState extends State<TypingTestPage> {
  int currentItem = 0;
  final List<String> wordIdList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd0d4ec),
      appBar: AppBar(
        backgroundColor: const Color(0xff647ebb),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${currentItem + 1}/${widget.wordModels.length}',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        LinearProgressBar(
          maxSteps: widget.wordModels.length,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Dots progress
          currentStep: currentItem + 1,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.grey,
        ),
        TypingGame(
          currentWord: widget.wordModels[currentItem],
          handleOnOkClick: _nextWord,
        ),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  void _nextWord(bool result) async {
    if (result) {
      wordIdList.add(widget.wordModels[currentItem].id!);
    }
    if (currentItem == widget.wordModels.length - 1) {
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
