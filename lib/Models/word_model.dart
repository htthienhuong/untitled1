import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  String? id;
  String? english;
  String? vietnam;
  String? topicId;
  bool isFavorite;

  WordModel({
    this.id,
    this.english,
    this.vietnam,
    this.topicId,
    this.isFavorite = false,
  });

  factory WordModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('data: $data');
    return WordModel(
      id: doc.id,
      english: data['english'],
      vietnam: data['vietnam'],
      topicId: data['topicId'],
    );
  }
}
