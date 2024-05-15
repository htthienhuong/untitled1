import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:untitled1/Services/WordServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/word_model.dart';
import 'essay_questions.dart';

class TypingPage extends StatefulWidget {
  final List<WordModel> wordModels;

  const TypingPage({super.key, required this.wordModels});

  @override
  State<TypingPage> createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  int currentItem = 0;
  final List<String> wordIdList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
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
      body: Column(children: [
        LinearProgressBar(
          maxSteps: widget.wordModels.length,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Dots progress
          currentStep: currentItem + 1,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.grey,
        ),
        EssayGame(
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
    print('currentItem: $currentItem');
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
