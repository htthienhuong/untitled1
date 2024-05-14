import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String name;
  String? avatarUrl; // Thêm trường để lưu URL của ảnh đại diện
  List<DocumentReference>? folderReferences;
  List<DocumentReference>? topicReferences;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl, // Đặt trường này là tùy chọn
    this.folderReferences,
    this.topicReferences,
  });

  // Factory constructor để tạo UserModel từ một tài liệu Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    List<DocumentReference> folderRefs =
        List<DocumentReference>.from(doc['Folders']);
    List<DocumentReference> topicRefs =
        List<DocumentReference>.from(doc['Topics']);

    return UserModel(
        id: doc.id,
        email: doc['Email'],
        name: doc['Name'],
        avatarUrl: doc['AvatarUrl'],
        folderReferences: folderRefs,
        topicReferences: topicRefs);
  }
}
