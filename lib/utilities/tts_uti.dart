import 'package:flutter_tts/flutter_tts.dart';

Future<void> speak(String? newVoiceText, bool isEnglish) async {
  FlutterTts flutterTts = FlutterTts();

  await flutterTts.setVolume(1.0);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setPitch(1.0);
  if (newVoiceText != null) {
    if (isEnglish) {
      await flutterTts.setLanguage('en-US');
    } else {
      await flutterTts.setLanguage('vi');
    }
  }

  // if (language != null) {
  //   await flutterTts.setLanguage(language);
  // } else {
  //   await flutterTts.setLanguage('en-US');
  // }

  if (newVoiceText != null) {
    if (newVoiceText.isNotEmpty) {
      print('xxxxxxxxxx');
      await flutterTts.speak(newVoiceText);
    }
  }
}
