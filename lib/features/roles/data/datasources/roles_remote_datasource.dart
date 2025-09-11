// lib/features/roles/data/datasources/roles_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_role_model.dart';
import '../models/permission_model.dart';
import '../models/role_assignment_model.dart';

abstract class RolesRemoteDataSource {
  Future<List<UserRoleModel>> getUserRoles();
  Future<List<PermissionModel>> getPermissions();
  Future<List<RoleAssignmentModel>> getRoleAssignments();
  Future<bool> checkPermission(String userId, String permission);
  Future<void> assignRole({
    required String userId,
    required String roleId,
    DateTime? expiresAt,
  });
  Future<void> revokeRole({required String userId, required String roleId});
}

class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  final FirebaseFirestore firestore;

  RolesRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<UserRoleModel>> getUserRoles() async {
    try {
      final querySnapshot = await firestore
          .collection('roles')
          .where('isActive', isEqualTo: true)
          .orderBy('level', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserRoleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load roles: ${e.toString()}');
    }
  }

  @override
  Future<List<PermissionModel>> getPermissions() async {
    try {
      final querySnapshot = await firestore
          .collection('permissions')
          .where('isActive', isEqualTo: true)
          .orderBy('category')
          .get();

      return querySnapshot.docs
          .map((doc) => PermissionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load permissions: ${e.toString()}');
    }
  }

  @override
  Future<List<RoleAssignmentModel>> getRoleAssignments() async {
    try {
      final querySnapshot = await firestore
          .collection('role_assignments')
          .where('isActive', isEqualTo: true)
          .orderBy('assignedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RoleAssignmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load role assignments: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkPermission(String userId, String permission) async {
    try {
      // Get user's role assignments
      final assignmentSnapshot = await firestore
          .collection('role_assignments')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      if (assignmentSnapshot.docs.isEmpty) return false;

      // Get role IDs
      final roleIds = assignmentSnapshot.docs
          .map((doc) => doc.data()['roleId'] as String)
          .toList();

      // Check if any role has the permission
      for (final roleId in roleIds) {
        final roleDoc = await firestore.collection('roles').doc(roleId).get();
        if (roleDoc.exists) {
          final roleData = roleDoc.data() as Map<String, dynamic>;
          final permissions = List<String>.from(roleData['permissions'] ?? []);
          if (permissions.contains(permission)) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check permission: ${e.toString()}');
    }
  }

  @override
  Future<void> assignRole({
    required String userId,
    required String roleId,
    DateTime? expiresAt,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get assignor details
      final assignorDoc =
          await firestore.collection('users').doc(user.uid).get();
      final assignorData = assignorDoc.data() as Map<String, dynamic>;

      // Get role details
      final roleDoc = await firestore.collection('roles').doc(roleId).get();
      final roleData = roleDoc.data() as Map<String, dynamic>;

      final assignment = RoleAssignmentModel(
        id: '',
        userId: userId,
        roleId: roleId,
        roleName: roleData['name'],
        assignedBy: user.uid,
        assignedByName: assignorData['name'],
        assignedAt: DateTime.now(),
        expiresAt: expiresAt,
        isActive: true,
      );

      await firestore
          .collection('role_assignments')
          .add(assignment.toFirestore());
    } catch (e) {
      throw Exception('Failed to assign role: ${e.toString()}');
    }
  }

  @override
  Future<void> revokeRole(
      {required String userId, required String roleId}) async {
    try {
      final assignmentSnapshot = await firestore
          .collection('role_assignments')
          .where('userId', isEqualTo: userId)
          .where('roleId', isEqualTo: roleId)
          .where('isActive', isEqualTo: true)
          .get();

      for (final doc in assignmentSnapshot.docs) {
        await doc.reference.update({'isActive': false});
      }
    } catch (e) {
      throw Exception('Failed to revoke role: ${e.toString()}');
    }
  }
}
