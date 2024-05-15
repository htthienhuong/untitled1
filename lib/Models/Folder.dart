import 'package:cloud_firestore/cloud_firestore.dart';

class Folder {
  String? documentId;
  final String folderName;
  String? description;
  List<DocumentReference>? Topics;
  final String userId; // Thêm trường userId vào Folder

  Folder({
    this.documentId,
    required this.folderName,
    this.description,
    Topics,
    required this.userId, // Thêm trường userId vào constructor
  }) : Topics = Topics ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': documentId,
      'folderName': folderName,
      'description': description,
      'userId': userId,
      'Topics': Topics,
    };
  }

  // Factory constructor để tạo Folder từ một tài liệu Firestore
  factory Folder.fromFirestore(DocumentSnapshot doc) {
    List<DocumentReference> topicRefs =
        List<DocumentReference>.from(doc['Topics']);
    return Folder(
      documentId: doc.id,
      folderName: doc['folderName'],
      description: doc["description"],
      Topics: topicRefs,
      userId:
          doc['userId'], // Gán giá trị cho trường userId từ tài liệu Firestore
    );
  }
}
