import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  final String? id;
  final String? topicImageUrl;
  final String topicName;
  final String? folderId;
  final String? userId;
  final bool isPublic;
  final String? userAvatarUrl;
  final String? userName;
  List<DocumentReference>? wordReferences;

  TopicModel({
    this.id,
    this.topicImageUrl,
    required this.topicName,
    this.folderId,
    this.userId,
    required this.isPublic,
    this.userAvatarUrl,
    this.userName,
    wordReferences,
  }) : wordReferences = wordReferences ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicImageUrl': topicImageUrl,
      'topicName': topicName,
      'folderId': folderId,
      'userId': userId,
      'isPublic': isPublic,
      'userAvatarUrl': userAvatarUrl,
      'userName': userName,
      'wordReferences': wordReferences,
    };
  }

  factory TopicModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<DocumentReference> wordsRefs =
        List<DocumentReference>.from(doc['wordReferences']);

    return TopicModel(
      id: doc.id,
      topicImageUrl: data['topicImageUrl'],
      topicName: data['topicName'],
      folderId: data['folderId'],
      userId: data['userId'],
      isPublic: data['isPublic'] ?? false,
      userAvatarUrl: data['userAvatarUrl'],
      userName: data['userName'],
      wordReferences: wordsRefs,
    );
  }

  static fromSnapshot(DocumentSnapshot<Object?> snapshot) {}
}
