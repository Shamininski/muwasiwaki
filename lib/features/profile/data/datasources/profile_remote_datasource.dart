// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile(UserProfile profile);
  Future<String> uploadProfileImage(String userId, File image);
  Future<void> deleteProfileImage(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final doc = await firestore.collection('user_profiles').doc(userId).get();

      if (!doc.exists) {
        // Create a basic profile from user data if profile doesn't exist
        final userDoc = await firestore.collection('users').doc(userId).get();
        if (!userDoc.exists) {
          throw Exception('User not found');
        }

        final userData = userDoc.data() as Map<String, dynamic>;
        final basicProfile = UserProfileModel(
          id: userId,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phoneNumber: null,
          district: null,
          profession: null,
          profileImageUrl: null,
          dateOfBirth: null,
          bio: null,
          createdAt:
              (userData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save the basic profile to Firestore
        await firestore
            .collection('user_profiles')
            .doc(userId)
            .set(basicProfile.toFirestore());

        return basicProfile;
      }

      return UserProfileModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfile profile) async {
    try {
      final profileModel = UserProfileModel.fromEntity(
        profile.copyWith(updatedAt: DateTime.now()),
      );

      await firestore
          .collection('user_profiles')
          .doc(profile.id)
          .set(profileModel.toFirestore(), SetOptions(merge: true));

      return profileModel;
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, File image) async {
    try {
      final ref = storage.ref().child('profile_images').child('$userId.jpg');
      final uploadTask = await ref.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update the profile with the new image URL
      await firestore.collection('user_profiles').doc(userId).update({
        'profileImageUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProfileImage(String userId) async {
    try {
      // Delete from Firebase Storage
      final ref = storage.ref().child('profile_images').child('$userId.jpg');
      await ref.delete();

      // Remove URL from profile
      await firestore.collection('user_profiles').doc(userId).update({
        'profileImageUrl': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete profile image: ${e.toString()}');
    }
  }
}
