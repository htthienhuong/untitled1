import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Models/word_model.dart';
import '../utilities/tts_uti.dart';

class MultipleChoiceGame extends StatefulWidget {
  final WordModel currentWord;
  final List<String> answerList;
  final Function? handleOnOkClick;
  const MultipleChoiceGame(
      {super.key,
        required this.currentWord,
        required this.answerList,
        this.handleOnOkClick});

  @override
  State<MultipleChoiceGame> createState() => _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  bool result = false;
  @override
  Widget build(BuildContext context) {
    return _buildLearningGame();
  }

  Widget _buildLearningGame() {
    result = false;
    return Expanded(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Card(
              color: const Color(0xff647ebb),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () async {
                        await speak(widget.currentWord.english!, true);
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.currentWord.english!,
                      style: const TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            itemCount: widget.answerList.length,
            itemBuilder: (context, index) {
              return _buildAnswer(widget.answerList[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswer(String text) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        child: TextButton(
            onPressed: () async {
              if (text == widget.currentWord.vietnam) {
                result = true;
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
                                'You are wonderful',
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
                    widget.handleOnOkClick!.call(result);
                  },
                ).show();
              } else {
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
                                text,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              const Text(
                                'The Answer Is',
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
                    widget.handleOnOkClick!.call(false);
                  },
                ).show();
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Color(0xff647ebb))),

            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                text,
                style: const TextStyle(
                  // Color(0xff647ebb)
                    color: Color.fromARGB(255, 28, 22, 120), fontWeight: FontWeight.w600, fontSize: 25),
              ),

            )
        )
    );
  }
}