import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/TopicModel.dart';

class TopicService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'Topics';
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');

  Future<void> updateTopic(String topicId, Map<String, dynamic> data) async {
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

// sửa trạng thái của topic
  Future<void> toggleTopicStatus(String topicId) async {
    try {
      // Lấy thông tin của topic từ Firestore
      DocumentSnapshot topicDoc =
          await _db.collection(_collectionName).doc(topicId).get();

      // Kiểm tra xem topic có tồn tại không
      if (topicDoc.exists) {
        // Lấy trạng thái hiện tại của topic
        bool currentStatus = topicDoc['isPublic'] ?? false;

        // Đảo ngược trạng thái
        bool newStatus = !currentStatus;

        // Cập nhật trạng thái mới của topic trong Firestore
        await _db
            .collection(_collectionName)
            .doc(topicId)
            .update({'isPublic': newStatus});
      } else {
        throw ('Topic not found');
      }
    } catch (error) {
      print("Error toggling topic status: $error");
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

  //
  Future<void> incrementView(String topicId) async {
    try {
      // Lấy thông tin của topic từ Firestore
      DocumentSnapshot topicDoc =
          await _db.collection(_collectionName).doc(topicId).get();

      // Kiểm tra xem topic có tồn tại không
      if (topicDoc.exists) {
        // Lấy giá trị hiện tại của trường 'view'
        String currentView = topicDoc['view'] ?? '0';

        // Chuyển đổi giá trị hiện tại thành kiểu int và tăng giá trị lên 1
        int newView = int.parse(currentView) + 1;

        // Chuyển đổi giá trị mới thành kiểu String
        String newViewString = newView.toString();

        // Cập nhật trường 'view' mới của topic trong Firestore
        await _db
            .collection(_collectionName)
            .doc(topicId)
            .update({'view': newViewString});
      } else {
        throw Exception('Topic not found');
      }
    } catch (error) {
      print("Error incrementing view for topic: $error");
      throw error;
    }
  }

  Future<void> deleteTopicWithUserReference(
      String topicId, String userId) async {
    try {
      DocumentReference topicRef = _db.collection('Topics').doc(topicId);

      QuerySnapshot wordsSnapshot = await _db
          .collection('Words')
          .where('topicId', isEqualTo: topicRef)
          .get();

      for (DocumentSnapshot doc in wordsSnapshot.docs) {
        await doc.reference.delete();
      }

      await topicRef.delete();

      DocumentReference userRef = _db.collection('User').doc(userId);

      await userRef.update({
        'Topics': FieldValue.arrayRemove([topicRef])
      });
    } catch (error) {
      print("Error deleting topic with user reference: $error");
    }
  } // lấy ra các topic public

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

  // Hàm để lấy tất cả các chủ đề chưa có trong một thư mục với userId trùng với userId của thư mục đó
  Future<List<TopicModel>> getTopicsNotInFolder(
      String userId, String folderId) async {
    try {
      // Lấy danh sách các chủ đề đã có trong thư mục
      DocumentSnapshot folderSnapshot =
          await _db.collection('Folder').doc(folderId).get();
      List<DocumentReference> topicReferences =
          List<DocumentReference>.from(folderSnapshot['Topics']);

      // Lấy danh sách các chủ đề có userId trùng với userId của thư mục
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      // Lọc ra các chủ đề chưa có trong thư mục
      List<TopicModel> topicsNotInFolder = [];
      for (DocumentSnapshot doc in querySnapshot.docs) {
        if (!topicReferences.contains(doc.reference)) {
          topicsNotInFolder.add(TopicModel.fromFirestore(doc));
        }
      }

      return topicsNotInFolder;
    } catch (error) {
      print("Error getting topics not in folder: $error");
      throw error;
    }
  }

  // Hàm để tìm kiếm các chủ đề công khai dựa trên một từ khóa
  Future<List<TopicModel>> searchPublicTopics(String keyword) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('isPublic', isEqualTo: true)
          .where('name', isGreaterThanOrEqualTo: keyword)
          .where('name', isLessThanOrEqualTo: keyword + '\uf8ff')
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
