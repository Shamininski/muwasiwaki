// lib/features/roles/data/models/permission_model.dart (Updated with extension)
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  const PermissionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.isActive,
  });

  factory PermissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PermissionModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  factory PermissionModel.fromEntity(Permission entity) {
    return PermissionModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      isActive: entity.isActive,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'isActive': isActive,
    };
  }

  Permission toEntity() {
    return Permission(
      id: id,
      name: name,
      description: description,
      category: category,
      isActive: isActive,
    );
  }
}

// Extension for local storage Map conversion
extension PermissionModelLocalStorage on PermissionModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'isActive': isActive,
    };
  }

  static PermissionModel fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}

// // lib/features/roles/data/models/permission_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/permission.dart';

// class PermissionModel extends Permission {
//   const PermissionModel({
//     required super.id,
//     required super.name,
//     required super.description,
//     required super.category,
//     required super.isActive,
//   });

//   factory PermissionModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return PermissionModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       category: data['category'] ?? '',
//       isActive: data['isActive'] ?? true,
//     );
//   }

//   factory PermissionModel.fromEntity(Permission entity) {
//     return PermissionModel(
//       id: entity.id,
//       name: entity.name,
//       description: entity.description,
//       category: entity.category,
//       isActive: entity.isActive,
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'description': description,
//       'category': category,
//       'isActive': isActive,
//     };
//   }

//   Permission toEntity() {
//     return Permission(
//       id: id,
//       name: name,
//       description: description,
//       category: category,
//       isActive: isActive,
//     );
//   }

//   PermissionModel copyWith({
//     String? id,
//     String? name,
//     String? description,
//     String? category,
//     bool? isActive,
//   }) {
//     return PermissionModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       isActive: isActive ?? this.isActive,
//     );
//   }
// }
