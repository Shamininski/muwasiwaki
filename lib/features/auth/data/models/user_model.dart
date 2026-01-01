// lib/features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../../../shared/enums/user_role.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: UserRoleExtension.fromStorageString(
          data['role'] ?? 'UserRole.member'), // ✅ Already correct
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ============== Commented out 01Jan2026 coz ofUserRole.name Error =============//
  // factory UserModel.fromFirestore(DocumentSnapshot doc) {
  //   final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return UserModel(
  //     id: doc.id,
  //     email: data['email'] ?? '',
  //     name: data['name'] ?? '',
  //     role: UserRole.values.firstWhere(
  //       (role) => role.toString() == data['role'],
  //       orElse: () => UserRole.member,
  //     ),
  //     createdAt: (data['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
  //   );
  // }
  // ============== Commented out 01Jan2026 coz ofUserRole.name Error =============//

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'role': role.toStorageString(), // Changed from role.toString()
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUser toEntity() {
    return AppUser(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
    );
  }
}
