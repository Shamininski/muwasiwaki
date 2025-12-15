// lib/features/membership/data/models/membership_application_model.dart (Updated with extension)
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/membership_application.dart';
import '../../domain/entities/family_member.dart';
import 'family_member_model.dart';

class MembershipApplicationModel extends MembershipApplication {
  const MembershipApplicationModel({
    required super.id,
    required super.applicantName,
    required super.email,
    required super.phone,
    required super.district,
    required super.profession,
    required super.dateOfEntry,
    required super.familyMembers,
    required super.status,
    required super.createdAt,
    super.reviewedBy,
    super.reviewedAt,
  });

  factory MembershipApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse family members
    List<FamilyMember> familyMembersList = [];
    if (data['familyMembers'] != null) {
      final familyMembersData = data['familyMembers'] as List<dynamic>;
      familyMembersList = familyMembersData
          .map((memberData) =>
              FamilyMemberModel.fromMap(memberData as Map<String, dynamic>)
                  .toEntity())
          .toList();
    }

    // Parse status
    ApplicationStatus status;
    try {
      status = ApplicationStatus.values.firstWhere(
        (s) => s.toString() == data['status'],
        orElse: () => ApplicationStatus.pending,
      );
    } catch (e) {
      status = ApplicationStatus.pending;
    }

    return MembershipApplicationModel(
      id: doc.id,
      applicantName: data['applicantName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      district: data['district'] ?? '',
      profession: data['profession'] ?? '',
      dateOfEntry: _parseTimestamp(data['dateOfEntry']),
      familyMembers: familyMembersList,
      status: status,
      createdAt: _parseTimestamp(data['createdAt']),
      reviewedBy: data['reviewedBy'],
      reviewedAt: data['reviewedAt'] != null
          ? _parseTimestamp(data['reviewedAt'])
          : null,
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'applicantName': applicantName,
      'email': email,
      'phone': phone,
      'district': district,
      'profession': profession,
      'dateOfEntry': Timestamp.fromDate(dateOfEntry),
      'familyMembers': familyMembers
          .map((member) => FamilyMemberModel.fromEntity(member).toMap())
          .toList(),
      'status': status.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }

  MembershipApplication toEntity() {
    return MembershipApplication(
      id: id,
      applicantName: applicantName,
      email: email,
      phone: phone,
      district: district,
      profession: profession,
      dateOfEntry: dateOfEntry,
      familyMembers: familyMembers,
      status: status,
      createdAt: createdAt,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
    );
  }

  factory MembershipApplicationModel.fromEntity(MembershipApplication entity) {
    return MembershipApplicationModel(
      id: entity.id,
      applicantName: entity.applicantName,
      email: entity.email,
      phone: entity.phone,
      district: entity.district,
      profession: entity.profession,
      dateOfEntry: entity.dateOfEntry,
      familyMembers: entity.familyMembers,
      status: entity.status,
      createdAt: entity.createdAt,
      reviewedBy: entity.reviewedBy,
      reviewedAt: entity.reviewedAt,
    );
  }
}

// Extension for local storage Map conversion
extension MembershipApplicationModelLocalStorage on MembershipApplicationModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applicantName': applicantName,
      'email': email,
      'phone': phone,
      'district': district,
      'profession': profession,
      'dateOfEntry': dateOfEntry.toIso8601String(),
      'familyMembers': familyMembers
          .map((member) => {
                'name': member.name,
                'dateOfBirth': member.dateOfBirth.toIso8601String(),
                'relationship': member.relationship,
              })
          .toList(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  static MembershipApplicationModel fromMap(Map<String, dynamic> map) {
    return MembershipApplicationModel(
      id: map['id'] ?? '',
      applicantName: map['applicantName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      district: map['district'] ?? '',
      profession: map['profession'] ?? '',
      dateOfEntry: DateTime.parse(map['dateOfEntry']),
      familyMembers: (map['familyMembers'] as List<dynamic>?)
              ?.map((member) => FamilyMember(
                    name: member['name'] ?? '',
                    dateOfBirth: DateTime.parse(member['dateOfBirth']),
                    relationship: member['relationship'] ?? '',
                  ))
              .toList() ??
          [],
      status: ApplicationStatus.values.firstWhere(
        (status) => status.toString() == map['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      reviewedBy: map['reviewedBy'],
      reviewedAt:
          map['reviewedAt'] != null ? DateTime.parse(map['reviewedAt']) : null,
    );
  }
}

// // lib/features/membership/data/models/membership_application_model.dart (Fixed)
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
//     required super.district,
//     required super.profession,
//     required super.reasonForJoining,
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
//       district: data['district'] ?? '',
//       profession: data['profession'] ?? '',
//       reasonForJoining: data['reasonForJoining'] ?? '',
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
//       'district': district,
//       'profession': profession,
//       'reasonForJoining': reasonForJoining,
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
//       district: district,
//       profession: profession,
//       reasonForJoining: reasonForJoining,
//       dateOfEntry: dateOfEntry,
//       familyMembers: familyMembers,
//       status: status,
//       createdAt: createdAt,
//       reviewedBy: reviewedBy,
//       reviewedAt: reviewedAt,
//     );
//   }

//   // Factory constructor for creating from entity
//   factory MembershipApplicationModel.fromEntity(MembershipApplication entity) {
//     return MembershipApplicationModel(
//       id: entity.id,
//       applicantName: entity.applicantName,
//       email: entity.email,
//       phone: entity.phone,
//       district: entity.district,
//       profession: entity.profession,
//       reasonForJoining: entity.reasonForJoining,
//       dateOfEntry: entity.dateOfEntry,
//       familyMembers: entity.familyMembers,
//       status: entity.status,
//       createdAt: entity.createdAt,
//       reviewedBy: entity.reviewedBy,
//       reviewedAt: entity.reviewedAt,
//     );
//   }

//   // Helper methods for validation
//   bool get isValid {
//     return applicantName.isNotEmpty &&
//         email.isNotEmpty &&
//         phone.isNotEmpty &&
//         district.isNotEmpty;
//   }

//   bool get canBeReviewed => status == ApplicationStatus.pending;

//   int get totalFamilyMembers => familyMembers.length;

//   List<FamilyMember> get children =>
//       familyMembers.where((m) => m.isChild).toList();

//   List<FamilyMember> get spouses =>
//       familyMembers.where((m) => m.isSpouse).toList();

//   // Additional helper methods for better functionality
//   bool get hasSpouse => spouses.isNotEmpty;

//   bool get hasChildren => children.isNotEmpty;

//   String get statusDisplayName {
//     switch (status) {
//       case ApplicationStatus.pending:
//         return 'Pending Review';
//       case ApplicationStatus.approved:
//         return 'Approved';
//       case ApplicationStatus.rejected:
//         return 'Rejected';
//     }
//   }

//   // Validation methods
//   bool get isEmailValid {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }

//   bool get isPhoneValid {
//     return phone.isNotEmpty && phone.length >= 10;
//   }

//   // Age calculation for applicant (if needed in future)
//   String get applicationAge {
//     final now = DateTime.now();
//     final difference = now.difference(createdAt);

//     if (difference.inDays > 30) {
//       final months = (difference.inDays / 30).floor();
//       return '${months}mo ago';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   // Create a copy with updated fields
//   MembershipApplicationModel copyWith({
//     String? id,
//     String? applicantName,
//     String? email,
//     String? phone,
//     String? district,
//     String? profession,
//     String? reasonForJoining,
//     DateTime? dateOfEntry,
//     List<FamilyMember>? familyMembers,
//     ApplicationStatus? status,
//     DateTime? createdAt,
//     String? reviewedBy,
//     DateTime? reviewedAt,
//   }) {
//     return MembershipApplicationModel(
//       id: id ?? this.id,
//       applicantName: applicantName ?? this.applicantName,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       district: district ?? this.district,
//       profession: profession ?? this.profession,
//       reasonForJoining: reasonForJoining ?? this.reasonForJoining,
//       dateOfEntry: dateOfEntry ?? this.dateOfEntry,
//       familyMembers: familyMembers ?? this.familyMembers,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       reviewedBy: reviewedBy ?? this.reviewedBy,
//       reviewedAt: reviewedAt ?? this.reviewedAt,
//     );
//   }

//   @override
//   String toString() {
//     return 'MembershipApplicationModel(id: $id, applicantName: $applicantName, status: $status)';
//   }
// }
