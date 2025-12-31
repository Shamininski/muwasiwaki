// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../../../shared/enums/user_role.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore);
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final UserCredential credential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: UserRole.member,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      return userModel;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get(const GetOptions(source: Source.cache)) // Try cache first
          .timeout(const Duration(seconds: 3));

      if (!userDoc.exists) {
        // Try server if cache fails
        final serverDoc = await firestore
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .timeout(const Duration(seconds: 5));

        if (!serverDoc.exists) return null;
        return UserModel.fromFirestore(serverDoc);
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }

  // ============== Commented out on 30 Dec 2025 ==========================
  // ================= Persist User Login ===================================
  // @override
  // Future<UserModel?> getCurrentUser() async {
  //   final User? currentUser = firebaseAuth.currentUser;
  //   if (currentUser == null) return null;

  //   final DocumentSnapshot<Map<String, dynamic>> userDoc = await firestore
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .get();

  //   if (!userDoc.exists) return null;

  //   return UserModel.fromFirestore(userDoc);
  // }
  // ============== Commented out on 30 Dec 2025 ==========================
}
