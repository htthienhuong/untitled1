import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/Models/word_model.dart';

class WordService {
  final CollectionReference Topics =
  FirebaseFirestore.instance.collection('Topics');
  final CollectionReference Words =
  FirebaseFirestore.instance.collection('Words');
  final CollectionReference Folder =
  FirebaseFirestore.instance.collection('Folders');
  final CollectionReference User =
  FirebaseFirestore.instance.collection('User');

  Future<List<WordModel>> getWordListFromRef(
      List<DocumentReference> wordReferences) async {
    print('wordReferences: ${wordReferences.length}');
    List<WordModel> wordModelList = [];
    for (DocumentReference wordRef in wordReferences) {
      print('wordRef: $wordRef');
      DocumentSnapshot wordSnap = await wordRef.get();
      print('wordSnap: ${wordSnap}');

      WordModel wordModel = WordModel.fromFirestore(wordSnap);
      print('wordModel: $wordModel');
      wordModelList.add(wordModel);
    }
    return wordModelList;
  }

  Future<void> addWord(String english, String vietnam, String topicId) async {
    try {
      DocumentReference wordRef = await Words.add({
        'english': english,
        'vietnam': vietnam,
        'topicId': topicId,
      });
      Topics.doc(topicId).update({
        'wordReferences': FieldValue.arrayUnion([wordRef])
      });
    } catch (error) {
      print('Error adding word: $error');
      throw error;
    }
  }

  Future<void> deleteWord(WordModel wordModel) async {
    try {
      DocumentReference wordRef = Words.doc(wordModel.id);
      await wordRef.delete();
      DocumentReference topicRef = Topics.doc(wordModel.topicId);
      print('topicRef: $topicRef');
      print('wordRef: $wordRef');
      await topicRef.update({
        'wordReferences': FieldValue.arrayRemove([wordRef])
      });
      print('delete ref done');
    } catch (error) {
      print('Error deleting word: $error');
    }
  }

  Future<void> updateWord(WordModel wordModel) async {
    try {
      await Words.doc(wordModel.id).update({
        'english': wordModel.english,
        'vietnam': wordModel.vietnam,
        'topicId': wordModel.topicId,
      });
    } catch (error) {
      print('Error updating word: $error');
      throw error;
    }
  }
}