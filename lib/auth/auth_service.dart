import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/app_data/app_data.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: ${e.toString()}");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: ");
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
    } catch (e) {
      log("Something went wrong");
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    print('user: $user');
    final cred = EmailAuthProvider.credential(
        email: AppData.userModel.email, password: currentPassword);
    print('cred: $cred');
    try {
      await user!.reauthenticateWithCredential(cred);
    } catch (e) {
      // currentPassword không đúng
      throw Exception("Current password is incorrect");
    }
    try {
      await user.updatePassword(newPassword);
      print('update Password: $newPassword');
    } catch (e) {
      print('xxxxxxxxxxxxxxxxxxxx');
      print('My e: $e');
      rethrow;
    }
  }


}


