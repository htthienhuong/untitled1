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
      FirebaseFirestore.instance.collection('Topic');
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> createUser(User user, String name) async {
    await FirebaseFirestore.instance.collection('User').doc(user.uid).set({
      'Email': user.email,
      'Name': name,
      'Folders': [],
      'Topics': [],
      'AvatarUrl': user.photoURL ?? '',
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

  Future<String> updateUserAvatar(String userId, Uint8List imageData) async {
    try {
      DocumentReference userRef = usersCollection.doc(userId);

      Reference ref =
          FirebaseStorage.instance.ref().child('avatars/$userId.jpg');

      UploadTask uploadTask = ref.putData(imageData);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await userRef.update({'AvatarUrl': downloadUrl});
      List<DocumentReference> topicRefs =
          (await userRef.get())['Topics'].cast<DocumentReference>() ?? [];
      for (DocumentReference topicRef in topicRefs) {
        print('topicRef: $topicRef');
        await topicRef.update({'userAvatarUrl': downloadUrl});
      }

      return downloadUrl;
    } catch (error) {
      print("Error updating user avatar: $error");
      throw error;
    }
  }

  Future<void> updateUserName(String userId, String name) async {
    try {
      DocumentReference userRef = usersCollection.doc(userId);
      await userRef.update({'Name': name});
      List<DocumentReference> topicRefs =
          (await userRef.get())['Topics'].cast<DocumentReference>() ?? [];
      for (DocumentReference topicRef in topicRefs) {
        print('topicRef: $topicRef');
        await topicRef.update({'userName': name});
      }
    } catch (error) {
      print("Error updateUserName: $error");
    }
  }

  Future<void> updateUserEmail(String userId, String email) async {
    try {
      DocumentReference userRef = usersCollection.doc(userId);
      await userRef.update({'Email': email});
    } catch (error) {
      print("Error updateUserName: $error");
    }
  }
}
