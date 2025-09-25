// lib/features/membership/data/datasources/membership_local_datasource.dart
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/membership_application.dart';
import '../models/membership_application_model.dart';

abstract class MembershipLocalDataSource {
  Future<List<MembershipApplicationModel>> getCachedApplications();
  Future<void> cacheApplications(List<MembershipApplicationModel> applications);
  Future<void> clearApplicationsCache();
  Future<void> cacheApplication(MembershipApplicationModel application);
  Future<MembershipApplicationModel?> getCachedApplication(String id);
}

class MembershipLocalDataSourceImpl implements MembershipLocalDataSource {
  final LocalStorageService localStorage;
  static const String _applicationsCacheKey = 'cached_applications';
  static const String _applicationPrefix = 'application_';

  MembershipLocalDataSourceImpl(this.localStorage);

  @override
  Future<List<MembershipApplicationModel>> getCachedApplications() async {
    try {
      final applicationsData = localStorage.getObject(_applicationsCacheKey);
      if (applicationsData != null &&
          applicationsData['applications'] is List) {
        final applicationsList = applicationsData['applications'] as List;
        return applicationsList
            .map((app) => MembershipApplicationModelLocalStorage.fromMap(
                app as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheApplications(
      List<MembershipApplicationModel> applications) async {
    try {
      final applicationsData = {
        'applications': applications.map((app) => app.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_applicationsCacheKey, applicationsData);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearApplicationsCache() async {
    try {
      await localStorage.remove(_applicationsCacheKey);

      // Also clear individual application cache
      final keys = localStorage.getKeys();
      for (final key in keys) {
        if (key.startsWith(_applicationPrefix)) {
          await localStorage.remove(key);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> cacheApplication(MembershipApplicationModel application) async {
    try {
      await localStorage.setObject(
          '$_applicationPrefix${application.id}', application.toMap());
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<MembershipApplicationModel?> getCachedApplication(String id) async {
    try {
      final applicationData = localStorage.getObject('$_applicationPrefix$id');
      if (applicationData != null) {
        return MembershipApplicationModelLocalStorage.fromMap(applicationData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}


// -----------------



// // lib/features/membership/data/datasources/membership_local_datasource.dart (Fixed)
// import '../../../../core/services/local_storage_service.dart';
// import '../../domain/entities/membership_application.dart';
// import '../models/membership_application_model.dart';
// import '../../domain/entities/family_member.dart';

// abstract class MembershipLocalDataSource {
//   Future<List<MembershipApplicationModel>> getCachedApplications();
//   Future<void> cacheApplications(List<MembershipApplicationModel> applications);
//   Future<void> clearApplicationsCache();
//   Future<void> cacheApplication(MembershipApplicationModel application);
//   Future<MembershipApplicationModel?> getCachedApplication(String id);
// }

// class MembershipLocalDataSourceImpl implements MembershipLocalDataSource {
//   final LocalStorageService localStorage;
//   static const String _applicationsCacheKey = 'cached_applications';
//   static const String _applicationPrefix = 'application_';

//   MembershipLocalDataSourceImpl(this.localStorage);

//   @override
//   Future<List<MembershipApplicationModel>> getCachedApplications() async {
//     try {
//       final applicationsData = localStorage.getObject(_applicationsCacheKey);
//       if (applicationsData != null && applicationsData['applications'] is List) {
//         final applicationsList = applicationsData['applications'] as List;
//         return applicationsList
//             .map((app) => MembershipApplicationModel.fromMap(app as Map<String, dynamic>))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<void> cacheApplications(List<MembershipApplicationModel> applications) async {
//     try {
//       final applicationsData = {
//         'applications': applications.map((app) => app.toMap()).toList(),
//         'cachedAt': DateTime.now().toIso8601String(),
//       };
//       await localStorage.setObject(_applicationsCacheKey, applicationsData);
//     } catch (e) {
//       // Silently fail - caching is not critical
//     }
//   }

//   @override
//   Future<void> clearApplicationsCache() async {
//     try {
//       await localStorage.remove(_applicationsCacheKey);
      
//       // Also clear individual application cache
//       final keys = localStorage.getKeys();
//       for (final key in keys) {
//         if (key.startsWith(_applicationPrefix)) {
//           await localStorage.remove(key);
//         }
//       }
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<void> cacheApplication(MembershipApplicationModel application) async {
//     try {
//       await localStorage.setObject('$_applicationPrefix${application.id}', application.toMap());
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<MembershipApplicationModel?> getCachedApplication(String id) async {
//     try {
//       final applicationData = localStorage.getObject('$_applicationPrefix$id');
//       if (applicationData != null) {
//         return MembershipApplicationModel.fromMap(applicationData);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// // Extension for MembershipApplicationModel to support Map conversion
// extension MembershipApplicationModelMap on MembershipApplicationModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'applicantName': applicantName,
//       'email': email,
//       'phone': phone,
//       'district': district,
//       'profession': profession,
//       'reasonForJoining': reasonForJoining,
//       'dateOfEntry': dateOfEntry.toIso8601String(),
//       'familyMembers': familyMembers.map((member) => {
//         'name': member.name,
//         'dateOfBirth': member.dateOfBirth.toIso8601String(),
//         'relationship': member.relationship,
//       }).toList(),
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
//       district: map['district'] ?? '',
//       profession: map['profession'] ?? '',
//       reasonForJoining: map['reasonForJoining'] ?? '',
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
//       reviewedAt: map['reviewedAt'] != null ? DateTime.parse(map['reviewedAt']) : null,
//     );
//   }
// }


// ------------------------------------==========


// // lib/features/membership/data/datasources/membership_local_datasource.dart
// import '../../../../core/services/local_storage_service.dart';
// import '../../domain/entities/family_member.dart';
// import '../../domain/entities/membership_application.dart';
// import '../models/membership_application_model.dart';

// abstract class MembershipLocalDataSource {
//   Future<List<MembershipApplicationModel>> getCachedApplications();
//   Future<void> cacheApplications(List<MembershipApplicationModel> applications);
//   Future<void> clearApplicationsCache();
//   Future<void> cacheApplication(MembershipApplicationModel application);
//   Future<MembershipApplicationModel?> getCachedApplication(String id);
// }

// class MembershipLocalDataSourceImpl implements MembershipLocalDataSource {
//   final LocalStorageService localStorage;
//   static const String _applicationsCacheKey = 'cached_applications';
//   static const String _applicationPrefix = 'application_';

//   MembershipLocalDataSourceImpl(this.localStorage);

//   @override
//   Future<List<MembershipApplicationModel>> getCachedApplications() async {
//     try {
//       final applicationsData = localStorage.getObject(_applicationsCacheKey);
//       if (applicationsData != null &&
//           applicationsData['applications'] is List) {
//         final applicationsList = applicationsData['applications'] as List;
//         return applicationsList
//             .map((app) =>
//                 MembershipApplicationModel.fromMap(app as Map<String, dynamic>))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<void> cacheApplications(
//       List<MembershipApplicationModel> applications) async {
//     try {
//       final applicationsData = {
//         'applications': applications.map((app) => app.toMap()).toList(),
//         'cachedAt': DateTime.now().toIso8601String(),
//       };
//       await localStorage.setObject(_applicationsCacheKey, applicationsData);
//     } catch (e) {
//       // Silently fail - caching is not critical
//     }
//   }

//   @override
//   Future<void> clearApplicationsCache() async {
//     try {
//       await localStorage.remove(_applicationsCacheKey);

//       // Also clear individual application cache
//       final keys = localStorage.getKeys();
//       for (final key in keys) {
//         if (key.startsWith(_applicationPrefix)) {
//           await localStorage.remove(key);
//         }
//       }
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<void> cacheApplication(MembershipApplicationModel application) async {
//     try {
//       await localStorage.setObject(
//           '$_applicationPrefix${application.id}', application.toMap());
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<MembershipApplicationModel?> getCachedApplication(String id) async {
//     try {
//       final applicationData = localStorage.getObject('$_applicationPrefix$id');
//       if (applicationData != null) {
//         return MembershipApplicationModel.fromMap(applicationData);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// // Extension for MembershipApplicationModel to support Map conversion
// extension MembershipApplicationModelMap on MembershipApplicationModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'applicantName': applicantName,
//       'email': email,
//       'phone': phone,
//       'district': district,
//       'profession': profession,
//       'reasonForJoining': reasonForJoining,
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
//       district: map['district'] ?? '',
//       profession: map['profession'] ?? '',
//       reasonForJoining: map['reasonForJoining'] ?? '',
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
