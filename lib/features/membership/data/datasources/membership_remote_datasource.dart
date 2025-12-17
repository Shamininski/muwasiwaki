// lib/features/membership/data/datasources/membership_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/membership_application_model.dart';
import '../../domain/entities/family_member.dart';

abstract class MembershipRemoteDataSource {
  Future<MembershipApplicationModel> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String subregion,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  });

  Future<List<MembershipApplicationModel>> getPendingApplications();
  Future<void> approveMembership(String applicationId, String reviewerId);
  Future<void> rejectMembership(String applicationId, String reviewerId);
}

class MembershipRemoteDataSourceImpl implements MembershipRemoteDataSource {
  final FirebaseFirestore firestore;

  MembershipRemoteDataSourceImpl(this.firestore);

  @override
  Future<MembershipApplicationModel> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String subregion,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  }) async {
    try {
      final docRef = await firestore.collection('membership_applications').add({
        'applicantName': applicantName,
        'email': email,
        'phone': phone,
        'subregion': subregion,
        'profession': profession,
        'dateOfEntry': Timestamp.fromDate(dateOfEntry),
        'familyMembers': familyMembers
            .map((member) => {
                  'name': member.name,
                  'dateOfBirth': Timestamp.fromDate(member.dateOfBirth),
                  'relationship': member.relationship,
                })
            .toList(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final doc = await docRef.get();
      return MembershipApplicationModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to apply for membership: $e');
    }
  }

  @override
  Future<List<MembershipApplicationModel>> getPendingApplications() async {
    try {
      final snapshot = await firestore
          .collection('membership_applications')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MembershipApplicationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch applications: $e');
    }
  }

  @override
  Future<void> approveMembership(
      String applicationId, String reviewerId) async {
    try {
      await firestore
          .collection('membership_applications')
          .doc(applicationId)
          .update({
        'status': 'approved',
        'reviewedBy': reviewerId,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to approve membership: $e');
    }
  }

  @override
  Future<void> rejectMembership(String applicationId, String reviewerId) async {
    try {
      await firestore
          .collection('membership_applications')
          .doc(applicationId)
          .update({
        'status': 'rejected',
        'reviewedBy': reviewerId,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reject membership: $e');
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../domain/entities/membership_application.dart';
// import '../models/membership_application_model.dart';
// import '../models/family_member_model.dart';
// import '../../domain/entities/family_member.dart';

// abstract class MembershipRemoteDataSource {
//   Future<void> applyForMembership({
//     required String applicantName,
//     required String email,
//     required String phone,
//     required String subregion,
//     required String profession,
//     required DateTime dateOfEntry,
//     required List<FamilyMember> familyMembers,
//   });

//   Future<List<MembershipApplicationModel>> getApplications();

//   Future<void> approveMembership({
//     required String applicationId,
//     required bool approved,
//   });

//   Future<MembershipApplicationModel?> getApplicationById(String id);
// }

// class MembershipRemoteDataSourceImpl implements MembershipRemoteDataSource {
//   final FirebaseFirestore firestore;

//   MembershipRemoteDataSourceImpl(this.firestore);

//   @override
//   Future<void> applyForMembership({
//     required String applicantName,
//     required String email,
//     required String phone,
//     required String subregion,
//     required String profession,
//     required DateTime dateOfEntry,
//     required List<FamilyMember> familyMembers,
//   }) async {
//     try {
//       final application = MembershipApplicationModel(
//         id: '', // Firestore will generate this
//         applicantName: applicantName,
//         email: email,
//         phone: phone,
//         subregion: subregion,
//         profession: profession,
//         dateOfEntry: dateOfEntry,
//         familyMembers: familyMembers
//             .map((fm) => FamilyMemberModel.fromEntity(fm))
//             .toList(),
//         status: ApplicationStatus.pending,
//         createdAt: DateTime.now(),
//         reviewedBy: null,
//         reviewedAt: null,
//       );

//       await firestore
//           .collection('membership_applications')
//           .add(application.toFirestore());
//     } catch (e) {
//       throw Exception('Failed to submit application: ${e.toString()}');
//     }
//   }

//   @override
//   Future<List<MembershipApplicationModel>> getApplications() async {
//     try {
//       final querySnapshot = await firestore
//           .collection('membership_applications')
//           .orderBy('createdAt', descending: true)
//           .get();

//       return querySnapshot.docs
//           .map((doc) => MembershipApplicationModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to load applications: ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> approveMembership({
//     required String applicationId,
//     required bool approved,
//   }) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw Exception('User not authenticated');

//       final status =
//           approved ? ApplicationStatus.approved : ApplicationStatus.rejected;

//       await firestore
//           .collection('membership_applications')
//           .doc(applicationId)
//           .update({
//         'status': status.toString(),
//         'reviewedBy': user.uid,
//         'reviewedAt': Timestamp.now(),
//       });
//     } catch (e) {
//       throw Exception('Failed to update application: ${e.toString()}');
//     }
//   }

//   @override
//   Future<MembershipApplicationModel?> getApplicationById(String id) async {
//     try {
//       final doc =
//           await firestore.collection('membership_applications').doc(id).get();

//       if (doc.exists) {
//         return MembershipApplicationModel.fromFirestore(doc);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get application by ID: ${e.toString()}');
//     }
//   }
// }
