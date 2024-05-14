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

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      // Thực hiện truy vấn để lấy ra người dùng với email nhất định
      QuerySnapshot querySnapshot =
          await usersCollection.where('Email', isEqualTo: email).get();

      // Kiểm tra xem có bất kỳ tài liệu nào phù hợp không
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy dữ liệu từ tài liệu đầu tiên trong kết quả truy vấn
        DocumentSnapshot doc = querySnapshot.docs.first;
        // Tạo một user từ dữ liệu của tài liệu Firestore
        return UserModel.fromFirestore(doc);
      } else {
        // Trả về null nếu không tìm thấy người dùng với email tương ứng
        return null;
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Error getting user by email: $error");
      // Trả về null trong trường hợp có lỗi
      return null;
    }
  }

  // Hàm để thêm một folder mới vào user
  Future<void> addFolderToUser(String userId, String folderName) async {
    try {
      // Tạo một tham chiếu đến user trong Firestore
      DocumentReference userRef = usersCollection.doc(userId);

      // Tạo một folder mới trong Firestore
      DocumentReference folderRef =
          await FirebaseFirestore.instance.collection('Folder').add({
        'Name': folderName,
        'userId': userId,
        'Topics': [], // Khởi tạo danh sách tham chiếu đến các topic là trống
      });

      // Lấy dữ liệu hiện tại của user
      DocumentSnapshot userDoc = await userRef.get();

      // Kiểm tra xem user có tồn tại không
      if (userDoc.exists) {
        // Thêm tham chiếu của folder mới vào danh sách Folders của user
        List<DocumentReference> folderRefs = userDoc['Folders'] != null
            ? List<DocumentReference>.from(userDoc['Folders'])
            : [];
        folderRefs.add(folderRef);

        // Cập nhật dữ liệu của user trong Firestore
        await userRef.update({'Folders': folderRefs});
      } else {
        print('User does not exist');
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Error adding folder to user: $error");
    }
  }

// đổi tên folder
  Future<void> updateFolderName(String folderId, String newName) async {
    try {
      // Tạo một tham chiếu đến folder trong Firestore
      DocumentReference folderRef =
          FirebaseFirestore.instance.collection('Folder').doc(folderId);

      // Cập nhật trường 'Name' của folder
      await folderRef.update({'Name': newName});
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Error updating folder name: $error");
    }
  }

// xóa folder
  Future<void> deleteFolder(String userId, String folderId) async {
    try {
      // Tạo một tham chiếu đến user trong Firestore
      DocumentReference userRef = usersCollection.doc(userId);

      // Lấy dữ liệu hiện tại của user
      DocumentSnapshot userDoc = await userRef.get();

      // Kiểm tra xem user có tồn tại không
      if (userDoc.exists) {
        // Lấy danh sách các tham chiếu của các folder của user
        List<DocumentReference> folderRefs = userDoc['Folders'] != null
            ? List<DocumentReference>.from(userDoc['Folders'])
            : [];

        // Xóa tham chiếu của folder cần xóa khỏi danh sách
        folderRefs.removeWhere((ref) => ref.id == folderId);

        // Cập nhật lại danh sách tham chiếu của user trong Firestore
        await userRef.update({'Folders': folderRefs});

        // Xóa folder khỏi Firestore
        await FirebaseFirestore.instance
            .collection('Folder')
            .doc(folderId)
            .delete();
      } else {
        print('User does not exist');
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Error deleting folder: $error");
    }
  }

// Hàm để lấy ra tất cả các thư mục của người dùng
  Future<List<Folder>> getAllFoldersByUserId(String userId) async {
    try {
      List<Folder> folders = [];
      // Lấy tham chiếu của tài liệu người dùng từ Firestore
      DocumentReference userRef = usersCollection.doc(userId);
      // Lấy dữ liệu của tài liệu người dùng từ Firestore
      DocumentSnapshot userDoc = await userRef.get();
      // Kiểm tra nếu tài liệu người dùng không null và có chứa trường 'Folders'
      if (userDoc != null &&
          (userDoc.data() as Map<String, dynamic>?)?.containsKey('Folders') ==
              true) {
        // Lấy danh sách tham chiếu của các thư mục từ tài liệu người dùng
        List<DocumentReference> folderRefs =
            (userDoc.data() as Map<String, dynamic>)['Folders']
                    .cast<DocumentReference>() ??
                [];
        // Lấy dữ liệu thực sự của các thư mục từ Firestore
        for (DocumentReference folderRef in folderRefs) {
          DocumentSnapshot folderDoc = await folderRef.get();
          folders.add(Folder.fromFirestore(folderDoc));
        }
      }
      return folders;
    } catch (error) {
      print("Error getting all folders by user ID: $error");
      throw error;
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
