import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/leader_boad_page/leading_board_model.dart';

class RecordService {
  final CollectionReference RecordCollection =
      FirebaseFirestore.instance.collection('Record');
  final CollectionReference WordCollection =
      FirebaseFirestore.instance.collection('Words');
  final CollectionReference UserCollection =
      FirebaseFirestore.instance.collection('User');

  Future<void> saveRecord({
    required String userId,
    required String topicId,
    required double point,
  }) async {
    try {
      QuerySnapshot querySnapshot =
          await RecordCollection.where('topicId', isEqualTo: topicId)
              .where('userId', isEqualTo: userId)
              .get();
      if (querySnapshot.docs.isEmpty) {
        await RecordCollection.add({
          'userId': userId,
          'topicId': topicId,
          'point': point,
        });
      } else {
        await querySnapshot.docs.first.reference.update({
          'point': point,
        });
      }
    } catch (e) {
      print('Error saving record: $e');
    }
  }

  Future<List<LeadingBoardModel>> getRecordsByTopicId(String topicId) async {
    print('getRecordsByTopicId');
    List<LeadingBoardModel> list = [];
    try {
    final querySnapshot =
        await RecordCollection.where('topicId', isEqualTo: topicId)
            .orderBy('point')
            .get();
    print('querySnapshot.docs: ${querySnapshot.docs}');
    for (DocumentSnapshot doc in querySnapshot.docs) {
      String userId = doc.get('userId');
      DocumentSnapshot userDoc = await UserCollection.doc(userId).get();

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      num point = doc.get('point');
      print('point: $point');
      LeadingBoardModel leadingBoardModel = LeadingBoardModel(
          userName: data['Name'],
          point: double.parse(point.toString()),
          userAvatar: data['AvatarUrl']);
      print('leadingBoardModel: $leadingBoardModel');
      list.add(leadingBoardModel);
      print('list: $list');
    }
    return list;
    } catch (e) {
      print('Error getting records: $e');
      return [];
    }
  }
}
