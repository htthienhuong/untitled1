import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/TopicModel.dart';

class TopicService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'Topics';
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');

  Future<void> updateTopicName(
      String topicId, Map<String, dynamic> data) async {
    try {
      await _db.collection(_collectionName).doc(topicId).update(data);
    } catch (error) {
      print("Error updating topic: $error");
    }
  }

  Future<List<TopicModel>> getTopicsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();
      List<TopicModel> topics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc))
          .toList();
      return topics;
    } catch (error) {
      print("Error getting topics by user ID: $error");
      throw error;
    }
  }

  Future<TopicModel> getTopicById(String topicId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection(_collectionName).doc(topicId).get();
      if (documentSnapshot.exists) {
        TopicModel topic = TopicModel.fromFirestore(documentSnapshot);
        return topic;
      } else {
        throw Exception('Topic with ID $topicId not found');
      }
    } catch (error) {
      print("Error getting topic by ID: $error");
      throw error;
    }
  }

  Future<List<TopicModel>> getAllTopics() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(_collectionName).get();
      List<TopicModel> topics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc))
          .toList();
      return topics;
    } catch (error) {
      print("Error getting all topics: $error");
      throw error;
    }
  }

  Future<String> addTopicWithUserReference({required TopicModel topic}) async {
    try {
      DocumentReference topicRef =
          await _db.collection(_collectionName).add(topic.toMap());

      DocumentReference userRef = _db.collection('User').doc(topic.userId);
      await userRef.update({
        'Topics': FieldValue.arrayUnion([topicRef])
      });
      return topicRef.id;
    } catch (error) {
      print("Error adding topic with user reference: $error");
      throw error;
    }
  }

  Future<void> deleteTopicWithUserReference(
      TopicModel topicModel, String userId) async {
    try {
      DocumentReference topicRef = _db.collection('Topics').doc(topicModel.id);

      for (DocumentReference wordRef in topicModel.wordReferences!) {
        await wordRef.delete();
      }

      await topicRef.delete();

      DocumentReference userRef = _db.collection('User').doc(userId);

      await userRef.update({
        'Topics': FieldValue.arrayRemove([topicRef])
      });
    } catch (error) {
      print("Error deleting topic with user reference: $error");
    }
  }

  Future<List<TopicModel>> getAllPublicTopics() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('isPublic', isEqualTo: true)
          .get();
      List<TopicModel> publicTopics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc))
          .toList();
      return publicTopics;
    } catch (error) {
      print("Error getting all public topics: $error");
      throw error;
    }
  }

  Future<List<TopicModel>> getAllTopicsByUserId(String userId) async {
    try {
      List<TopicModel> topics = [];
      DocumentReference userRef = usersCollection.doc(userId);
      List<DocumentReference> topicRefs =
          (await userRef.get())['Topics'].cast<DocumentReference>() ?? [];
      for (DocumentReference topicRef in topicRefs) {
        DocumentSnapshot topicDoc = await topicRef.get();
        topics.add(TopicModel.fromFirestore(topicDoc));
      }
      return topics;
    } catch (error) {
      print("Error getting all topics by user ID: $error");
      throw error;
    }
  }

  // Hàm để tìm kiếm các chủ đề công khai dựa trên một từ khóa
  Future<List<TopicModel>> searchPublicTopics(String keyword) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('isPublic', isEqualTo: true)
          .where('topicName', isGreaterThanOrEqualTo: keyword)
          .where('topicName', isLessThanOrEqualTo: keyword + '\uf8ff')
          .get();
      List<TopicModel> publicTopics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc))
          .toList();
      return publicTopics;
    } catch (error) {
      print("Error searching public topics: $error");
      throw error;
    }
  }
}
