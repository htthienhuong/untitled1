import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Models/Folder.dart';
import '../Models/TopicModel.dart';
import '../Models/UserModel.dart';

class UserService {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('User');
  final CollectionReference foldersCollection =
  FirebaseFirestore.instance.collection('Folder');
  final CollectionReference topicsCollection =
  FirebaseFirestore.instance.collection('Topics');
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> createUser(User user, String name) async {
    await FirebaseFirestore.instance.collection('User').doc(user.uid).set({
      'Email': user.email,
      'Name': name,
      'Folders': [],
      'Topics': [],
      'AvatarUrl': user.photoURL,
    });
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return UserModel(
            id: doc.id,
            email: data!['Email'],
            name: data['Name'],
            avatarUrl: data['AvatarUrl']);
      } else {
        return null;
      }
    } catch (error) {
      print("Error getting user by id: $error");
      return null;
    }
  }

  Future<void> updateUserAvatar(String userId, Uint8List imageData) async {
    try {
      // Tạo tham chiếu đến ảnh đại diện trên Firebase Storage

      Reference ref =
      FirebaseStorage.instance.ref().child('avatars/$userId/avatar.jpg');

      // Tải lên ảnh đại diện lên Firebase Storage
      UploadTask uploadTask = ref.putData(imageData);

      // Chờ cho quá trình tải lên hoàn tất và lấy URL của ảnh
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Cập nhật URL của ảnh đại diện trong tài liệu người dùng trên Firestore
      await usersCollection.doc(userId).update({'AvatarUrl': downloadUrl});
    } catch (error) {
      print("Error updating user avatar: $error");
      throw error;
    }
  }
}