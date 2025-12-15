// Update to lib/features/membership/data/datasources/membership_remote_datasource.dart
// Adding the missing getApplicationById method

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/membership_application.dart';
import '../models/membership_application_model.dart';
import '../models/family_member_model.dart';
import '../../domain/entities/family_member.dart';

abstract class MembershipRemoteDataSource {
  Future<void> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String district,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  });

  Future<List<MembershipApplicationModel>> getApplications();

  Future<void> approveMembership({
    required String applicationId,
    required bool approved,
  });

  Future<MembershipApplicationModel?> getApplicationById(String id);
}

class MembershipRemoteDataSourceImpl implements MembershipRemoteDataSource {
  final FirebaseFirestore firestore;

  MembershipRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String district,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  }) async {
    try {
      final application = MembershipApplicationModel(
        id: '', // Firestore will generate this
        applicantName: applicantName,
        email: email,
        phone: phone,
        district: district,
        profession: profession,
        dateOfEntry: dateOfEntry,
        familyMembers: familyMembers
            .map((fm) => FamilyMemberModel.fromEntity(fm))
            .toList(),
        status: ApplicationStatus.pending,
        createdAt: DateTime.now(),
        reviewedBy: null,
        reviewedAt: null,
      );

      await firestore
          .collection('membership_applications')
          .add(application.toFirestore());
    } catch (e) {
      throw Exception('Failed to submit application: ${e.toString()}');
    }
  }

  @override
  Future<List<MembershipApplicationModel>> getApplications() async {
    try {
      final querySnapshot = await firestore
          .collection('membership_applications')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MembershipApplicationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load applications: ${e.toString()}');
    }
  }

  @override
  Future<void> approveMembership({
    required String applicationId,
    required bool approved,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final status =
          approved ? ApplicationStatus.approved : ApplicationStatus.rejected;

      await firestore
          .collection('membership_applications')
          .doc(applicationId)
          .update({
        'status': status.toString(),
        'reviewedBy': user.uid,
        'reviewedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update application: ${e.toString()}');
    }
  }

  @override
  Future<MembershipApplicationModel?> getApplicationById(String id) async {
    try {
      final doc =
          await firestore.collection('membership_applications').doc(id).get();

      if (doc.exists) {
        return MembershipApplicationModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get application by ID: ${e.toString()}');
    }
  }
}
