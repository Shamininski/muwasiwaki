// lib/features/membership/data/models/membership_application_model.dart (Updated with extension)

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/membership_application.dart';
import '../../domain/entities/family_member.dart';

class MembershipApplicationModel extends MembershipApplication {
  const MembershipApplicationModel({
    required super.id,
    required super.applicantName,
    required super.email,
    required super.phone,
    required super.subregion,
    required super.profession,
    super.nidaNumber,
    required super.dateOfEntry,
    required super.familyMembers,
    required super.status,
    required super.createdAt,
    super.reviewedBy,
    super.reviewedAt,
  });

  factory MembershipApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final familyMembersData = data['familyMembers'] as List<dynamic>? ?? [];
    final familyMembers = familyMembersData.map((fm) {
      return FamilyMember(
        name: fm['name'] ?? '',
        dateOfBirth: (fm['dateOfBirth'] as Timestamp).toDate(),
        relationship: fm['relationship'] ?? '',
      );
    }).toList();

    return MembershipApplicationModel(
      id: doc.id,
      applicantName: data['applicantName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      subregion: data['subregion'] ?? '',
      profession: data['profession'] ?? '',
      nidaNumber: data['nidaNumber'],
      dateOfEntry:
          (data['dateOfEntry'] as Timestamp?)?.toDate() ?? DateTime.now(),
      familyMembers: familyMembers,
      status: _parseStatus(data['status']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedBy: data['reviewedBy'],
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
    );
  }

  static ApplicationStatus _parseStatus(dynamic status) {
    if (status == 'approved') return ApplicationStatus.approved;
    if (status == 'rejected') return ApplicationStatus.rejected;
    return ApplicationStatus.pending;
  }

  MembershipApplication toEntity() {
    return MembershipApplication(
      id: id,
      applicantName: applicantName,
      email: email,
      phone: phone,
      subregion: subregion,
      profession: profession,
      nidaNumber: nidaNumber,
      dateOfEntry: dateOfEntry,
      familyMembers: familyMembers,
      status: status,
      createdAt: createdAt,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
    );
  }

  // --- Added: local storage serialization (JSON friendly) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applicantName': applicantName,
      'email': email,
      'phone': phone,
      'subregion': subregion,
      'profession': profession,
      'nidaNumber': nidaNumber,
      'dateOfEntry': dateOfEntry.toIso8601String(),
      'familyMembers': familyMembers
          .map((m) => {
                'name': m.name,
                'dateOfBirth': m.dateOfBirth.toIso8601String(),
                'relationship': m.relationship,
              })
          .toList(),
      'status': status.toString(), // store as string
      'createdAt': createdAt.toIso8601String(),
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  static MembershipApplicationModel fromMap(Map<String, dynamic> map) {
    final familyMembersList = (map['familyMembers'] as List<dynamic>?)
            ?.map((member) => FamilyMember(
                  name: member['name'] ?? '',
                  dateOfBirth: DateTime.parse(member['dateOfBirth'] as String),
                  relationship: member['relationship'] ?? '',
                ))
            .toList() ??
        [];

    ApplicationStatus status = ApplicationStatus.pending;
    final statusRaw = map['status'];
    if (statusRaw is String) {
      status = _parseStatus(statusRaw);
    }

    return MembershipApplicationModel(
      id: map['id'] ?? '',
      applicantName: map['applicantName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      subregion: map['subregion'] ?? '',
      profession: map['profession'] ?? '',
      nidaNumber: map['nidaNumber'] ?? '',
      dateOfEntry:
          DateTime.tryParse(map['dateOfEntry'] ?? '') ?? DateTime.now(),
      familyMembers: familyMembersList,
      status: status,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      reviewedBy: map['reviewedBy'],
      reviewedAt: map['reviewedAt'] != null
          ? DateTime.tryParse(map['reviewedAt'])
          : null,
    );
  }

  // --- Added: Firestore serialization (use when writing to Firestore) ---
  Map<String, dynamic> toFirestore() {
    return {
      'applicantName': applicantName,
      'email': email,
      'phone': phone,
      'subregion': subregion,
      'profession': profession,
      'nidaNumber': nidaNumber,
      'dateOfEntry': Timestamp.fromDate(dateOfEntry),
      'familyMembers': familyMembers
          .map((m) => {
                'name': m.name,
                'dateOfBirth': Timestamp.fromDate(m.dateOfBirth),
                'relationship': m.relationship,
              })
          .toList(),
      'status': status == ApplicationStatus.approved
          ? 'approved'
          : status == ApplicationStatus.rejected
              ? 'rejected'
              : 'pending',
      'createdAt': Timestamp.fromDate(createdAt),
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }
}







// Added on 17 Dec2025, but Commented out for future ref incase probs of method signs arise across files
//  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/membership_application.dart';
// import '../../domain/entities/family_member.dart';

// class MembershipApplicationModel extends MembershipApplication {
//   const MembershipApplicationModel({
//     required super.id,
//     required super.applicantName,
//     required super.email,
//     required super.phone,
//     required super.subregion,
//     required super.profession,
//     required super.dateOfEntry,
//     required super.familyMembers,
//     required super.status,
//     required super.createdAt,
//     super.reviewedBy,
//     super.reviewedAt,
//   });

//   factory MembershipApplicationModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     final familyMembersData = data['familyMembers'] as List<dynamic>? ?? [];
//     final familyMembers = familyMembersData.map((fm) {
//       return FamilyMember(
//         name: fm['name'] ?? '',
//         dateOfBirth: (fm['dateOfBirth'] as Timestamp).toDate(),
//         relationship: fm['relationship'] ?? '',
//       );
//     }).toList();

//     return MembershipApplicationModel(
//       id: doc.id,
//       applicantName: data['applicantName'] ?? '',
//       email: data['email'] ?? '',
//       phone: data['phone'] ?? '',
//       subregion: data['subregion'] ?? '',
//       profession: data['profession'] ?? '',
//       dateOfEntry:
//           (data['dateOfEntry'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       familyMembers: familyMembers,
//       status: _parseStatus(data['status']),
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       reviewedBy: data['reviewedBy'],
//       reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
//     );
//   }

//   static ApplicationStatus _parseStatus(dynamic status) {
//     if (status == 'approved') return ApplicationStatus.approved;
//     if (status == 'rejected') return ApplicationStatus.rejected;
//     return ApplicationStatus.pending;
//   }

//   MembershipApplication toEntity() {
//     return MembershipApplication(
//       id: id,
//       applicantName: applicantName,
//       email: email,
//       phone: phone,
//       subregion: subregion,
//       profession: profession,
//       dateOfEntry: dateOfEntry,
//       familyMembers: familyMembers,
//       status: status,
//       createdAt: createdAt,
//       reviewedBy: reviewedBy,
//       reviewedAt: reviewedAt,
//     );
//   }
// }
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/membership_application.dart';
// import '../../domain/entities/family_member.dart';
// import 'family_member_model.dart';

// class MembershipApplicationModel extends MembershipApplication {
//   const MembershipApplicationModel({
//     required super.id,
//     required super.applicantName,
//     required super.email,
//     required super.phone,
//     required super.subregion,
//     required super.profession,
//     required super.dateOfEntry,
//     required super.familyMembers,
//     required super.status,
//     required super.createdAt,
//     super.reviewedBy,
//     super.reviewedAt,
//   });

//   factory MembershipApplicationModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     // Parse family members
//     List<FamilyMember> familyMembersList = [];
//     if (data['familyMembers'] != null) {
//       final familyMembersData = data['familyMembers'] as List<dynamic>;
//       familyMembersList = familyMembersData
//           .map((memberData) =>
//               FamilyMemberModel.fromMap(memberData as Map<String, dynamic>)
//                   .toEntity())
//           .toList();
//     }

//     // Parse status
//     ApplicationStatus status;
//     try {
//       status = ApplicationStatus.values.firstWhere(
//         (s) => s.toString() == data['status'],
//         orElse: () => ApplicationStatus.pending,
//       );
//     } catch (e) {
//       status = ApplicationStatus.pending;
//     }

//     return MembershipApplicationModel(
//       id: doc.id,
//       applicantName: data['applicantName'] ?? '',
//       email: data['email'] ?? '',
//       phone: data['phone'] ?? '',
//       subregion: data['subregion'] ?? '',
//       profession: data['profession'] ?? '',
//       dateOfEntry: _parseTimestamp(data['dateOfEntry']),
//       familyMembers: familyMembersList,
//       status: status,
//       createdAt: _parseTimestamp(data['createdAt']),
//       reviewedBy: data['reviewedBy'],
//       reviewedAt: data['reviewedAt'] != null
//           ? _parseTimestamp(data['reviewedAt'])
//           : null,
//     );
//   }

//   static DateTime _parseTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return timestamp.toDate();
//     } else if (timestamp is String) {
//       return DateTime.parse(timestamp);
//     } else {
//       return DateTime.now();
//     }
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'applicantName': applicantName,
//       'email': email,
//       'phone': phone,
//       'subregion': subregion,
//       'profession': profession,
//       'dateOfEntry': Timestamp.fromDate(dateOfEntry),
//       'familyMembers': familyMembers
//           .map((member) => FamilyMemberModel.fromEntity(member).toMap())
//           .toList(),
//       'status': status.toString(),
//       'createdAt': Timestamp.fromDate(createdAt),
//       'reviewedBy': reviewedBy,
//       'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
//     };
//   }

//   MembershipApplication toEntity() {
//     return MembershipApplication(
//       id: id,
//       applicantName: applicantName,
//       email: email,
//       phone: phone,
//       subregion: subregion,
//       profession: profession,
//       dateOfEntry: dateOfEntry,
//       familyMembers: familyMembers,
//       status: status,
//       createdAt: createdAt,
//       reviewedBy: reviewedBy,
//       reviewedAt: reviewedAt,
//     );
//   }

//   factory MembershipApplicationModel.fromEntity(MembershipApplication entity) {
//     return MembershipApplicationModel(
//       id: entity.id,
//       applicantName: entity.applicantName,
//       email: entity.email,
//       phone: entity.phone,
//       subregion: entity.subregion,
//       profession: entity.profession,
//       dateOfEntry: entity.dateOfEntry,
//       familyMembers: entity.familyMembers,
//       status: entity.status,
//       createdAt: entity.createdAt,
//       reviewedBy: entity.reviewedBy,
//       reviewedAt: entity.reviewedAt,
//     );
//   }
// }

// // Extension for local storage Map conversion
// extension MembershipApplicationModelLocalStorage on MembershipApplicationModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'applicantName': applicantName,
//       'email': email,
//       'phone': phone,
//       'subregion': subregion,
//       'profession': profession,
//       'dateOfEntry': dateOfEntry.toIso8601String(),
//       'familyMembers': familyMembers
//           .map((member) => {
//                 'name': member.name,
//                 'dateOfBirth': member.dateOfBirth.toIso8601String(),
//                 'relationship': member.relationship,
//               })
//           .toList(),
//       'status': status.toString(),
//       'createdAt': createdAt.toIso8601String(),
//       'reviewedBy': reviewedBy,
//       'reviewedAt': reviewedAt?.toIso8601String(),
//     };
//   }

//   static MembershipApplicationModel fromMap(Map<String, dynamic> map) {
//     return MembershipApplicationModel(
//       id: map['id'] ?? '',
//       applicantName: map['applicantName'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//       subregion: map['subregion'] ?? '',
//       profession: map['profession'] ?? '',
//       dateOfEntry: DateTime.parse(map['dateOfEntry']),
//       familyMembers: (map['familyMembers'] as List<dynamic>?)
//               ?.map((member) => FamilyMember(
//                     name: member['name'] ?? '',
//                     dateOfBirth: DateTime.parse(member['dateOfBirth']),
//                     relationship: member['relationship'] ?? '',
//                   ))
//               .toList() ??
//           [],
//       status: ApplicationStatus.values.firstWhere(
//         (status) => status.toString() == map['status'],
//         orElse: () => ApplicationStatus.pending,
//       ),
//       createdAt: DateTime.parse(map['createdAt']),
//       reviewedBy: map['reviewedBy'],
//       reviewedAt:
//           map['reviewedAt'] != null ? DateTime.parse(map['reviewedAt']) : null,
//     );
//   }
// }
