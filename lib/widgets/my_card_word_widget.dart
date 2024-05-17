import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import '../Models/word_model.dart';
import '../utilities/tts_uti.dart';

class CardWordWidget extends StatefulWidget {
  final WordModel wordModel;
  const CardWordWidget({super.key, required this.wordModel});

  @override
  State<CardWordWidget> createState() => _CardWordWidgetState();
}

class _CardWordWidgetState extends State<CardWordWidget> {
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  word,
                  style: const TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Epilogue"),
                )),
          ],
        ),
      ),
    );
  }
}