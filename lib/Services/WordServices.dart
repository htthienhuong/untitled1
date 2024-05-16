import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/Models/word_model.dart';

class WordService {
  final CollectionReference Topics =
  FirebaseFirestore.instance.collection('Topics');
  final CollectionReference Words =
  FirebaseFirestore.instance.collection('Words');
  final CollectionReference WordLearnCount =
  FirebaseFirestore.instance.collection('WordLearnCount');
  final CollectionReference Folder =
  FirebaseFirestore.instance.collection('Folder');
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

  Future<void> updateWordLearnCount(String wordId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
      await WordLearnCount.where('userId', isEqualTo: userId)
          .where('wordId', isEqualTo: wordId)
          .get();

      if (querySnapshot.size == 0) {
        await WordLearnCount.doc().set(
            {'wordId': wordId, 'userId': userId, 'count': 0, 'starred': false});
      } else {
        await querySnapshot.docs.first.reference
            .update({'count': FieldValue.increment(1)});
      }
    } catch (error) {
      print('Error adding word: $error');
      throw error;
    }
  }

  Future<void> updateWordStatus(
      String wordId, String userId, bool status) async {
    try {
      QuerySnapshot querySnapshot =
      await WordLearnCount.where('userId', isEqualTo: userId)
          .where('wordId', isEqualTo: wordId)
          .get();

      if (querySnapshot.size == 0) {
        await WordLearnCount.doc().set(
            {'wordId': wordId, 'userId': userId, 'count': 0, 'starred': false});
      } else {
        await querySnapshot.docs.first.reference.update({'starred': status});
      }
    } catch (error) {
      print('Error adding word: $error');
      throw error;
    }
  }

  Future<int> getWordLearnCount(String wordId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
      await WordLearnCount.where('userId', isEqualTo: userId)
          .where('wordId', isEqualTo: wordId)
          .get();

      return querySnapshot.docs.first.get('count');
    } catch (error) {
      print('Error adding word: $error');
      throw error;
    }
  }

  Future<bool> getWordStar(String wordId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
      await WordLearnCount.where('userId', isEqualTo: userId)
          .where('wordId', isEqualTo: wordId)
          .get();

      if (querySnapshot.size == 0) {
        await WordLearnCount.doc().set(
            {'wordId': wordId, 'userId': userId, 'count': 0, 'starred': false});
        return false;
      } else {
        return querySnapshot.docs.first.get('starred');
      }
    } catch (error) {
      print('Error adding word: $error');
      throw error;
    }
  }

  Future<List<WordModel>> getWordStarList(String userId) async {
    List<WordModel> wordModelList = [];
    try {
      QuerySnapshot querySnapshot =
      await WordLearnCount.where('userId', isEqualTo: userId)
          .where('starred', isEqualTo: true)
          .get();
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        DocumentSnapshot wordSnap = await Words.doc(data['wordId']).get();
        WordModel wordModel = WordModel.fromFirestore(wordSnap);
        wordModelList.add(wordModel);
      }
      return wordModelList;
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