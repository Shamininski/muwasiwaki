// lib/features/roles/data/models/permission_model.dart
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
