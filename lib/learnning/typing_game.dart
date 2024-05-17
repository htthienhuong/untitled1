import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/word_model.dart';
import '../utilities/tts_uti.dart';

class TypingGame extends StatefulWidget {
  final WordModel currentWord;
  final Function? handleOnOkClick;
  const TypingGame(
      {super.key, required this.currentWord, this.handleOnOkClick});

  @override
  State<TypingGame> createState() => _TypingGameState();
}

class _TypingGameState extends State<TypingGame> {
  bool result = false;
  final TextEditingController _textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    result = false;
    _textEditingController.clear();
    return _buildLearningGame();
  }

  Widget _buildLearningGame() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      speak(widget.currentWord.english, true);
                    },
                    icon: const Icon(
                      Icons.volume_up,
                      size: 64,
                      color: Colors.white,
                    )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.currentWord.english!,
                    style: const TextStyle(fontSize: 64, color: Color.fromARGB(255, 28, 22, 120)),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
              child: TextField(
                focusNode: focusNode,
                autofocus: true,
                decoration: const InputDecoration(hintText: "Your answer"),
                controller: _textEditingController,
                onSubmitted: (value) {
                  if (value == widget.currentWord.vietnam) {
                    result = true;
                    _showCorrectDialog();
                  } else {
                    _showWrongDialog();
                  }
                },
              ))
        ],
      ),
    );
  }

  void _showCorrectDialog() {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/happy_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "Great!",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      btnOkText: "Continue",
      btnOkOnPress: () {
        setState(() {
          // update state

          focusNode.requestFocus();
        });

        widget.handleOnOkClick!.call(result);
      },
    ).show();
  }

  void _showWrongDialog() {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/sad_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Better next time',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentWord.english!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    'Right answer',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    widget.currentWord.vietnam!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      btnOkColor: Colors.blue,
      btnOkText: "Continue",
      btnOkOnPress: () {
        widget.handleOnOkClick!.call(result);
      },
    ).show();
  }
}