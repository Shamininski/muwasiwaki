// lib/shared/enums/user_role.dart  Changed on 08-Nov-2025
import 'package:flutter/material.dart';

enum UserRole {
  member,
  chairman,
  viceChairman,
  secretary,
  viceSecretary,
  accountant,
  subregionRepresentative,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.member:
        return 'Member';
      case UserRole.chairman:
        return 'Chairman';
      case UserRole.viceChairman:
        return 'Vice Chairman';
      case UserRole.secretary:
        return 'Secretary';
      case UserRole.viceSecretary:
        return 'Vice Secretary';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.subregionRepresentative:
        return 'Subregion Representative';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get description {
    switch (this) {
      case UserRole.member:
        return 'Regular organization member with basic access rights';
      case UserRole.chairman:
        return 'Organization chairman with full administrative authority';
      case UserRole.viceChairman:
        return 'Vice chairman with delegated administrative responsibilities';
      case UserRole.secretary:
        return 'Secretary responsible for documentation and communication';
      case UserRole.viceSecretary:
        return 'Assistant secretary with limited secretarial duties';
      case UserRole.accountant:
        return 'Financial officer responsible for accounting and membership approval';
      case UserRole.subregionRepresentative:
        return 'Representative for a specific subregion or region';
      case UserRole.admin:
        return 'System administrator with technical and full access privileges';
    }
  }

  int get level {
    switch (this) {
      case UserRole.member:
        return 1;
      case UserRole.subregionRepresentative:
        return 2;
      case UserRole.viceSecretary:
        return 3;
      case UserRole.accountant:
        return 4;
      case UserRole.secretary:
        return 5;
      case UserRole.viceChairman:
        return 6;
      case UserRole.chairman:
        return 7;
      case UserRole.admin:
        return 8;
    }
  }

  bool get canApproveMembers {
    return level >= 4; // Accountant level and above
  }

  bool get canCreateNews {
    return level >= 2; // Subregion Representative level and above
  }

  bool get canEditNews {
    return level >= 3; // Vice Secretary level and above
  }

  bool get canDeleteNews {
    return level >= 5; // Secretary level and above
  }

  bool get canManageRoles {
    return level >= 6; // Vice Chairman level and above
  }

  bool get canManageUsers {
    return level >= 7; // Chairman level and above
  }

  bool get canManageSystem {
    return this == UserRole.admin;
  }

  bool get canViewAllMembers {
    return level >= 2; // Subregion Representative level and above
  }

  bool get canManageEvents {
    return level >= 3; // Vice Secretary level and above
  }

  bool get canViewReports {
    return level >= 4; // Accountant level and above
  }

  bool get canManageFinances {
    return this == UserRole.accountant || level >= 7;
  }

  List<String> get permissions {
    switch (this) {
      case UserRole.member:
        return [
          'read_news',
          'update_own_profile',
          'view_public_content',
        ];
      case UserRole.subregionRepresentative:
        return [
          'read_news',
          'create_news',
          'update_own_profile',
          'view_members',
          'manage_subregion_activities',
        ];
      case UserRole.viceSecretary:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'update_own_profile',
          'view_members',
          'manage_communications',
          'manage_events',
        ];
      case UserRole.accountant:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'update_own_profile',
          'view_members',
          'approve_members',
          'reject_members',
          'manage_finances',
          'view_reports',
          'manage_membership_fees',
        ];
      case UserRole.secretary:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'delete_news',
          'update_own_profile',
          'view_members',
          'approve_members',
          'reject_members',
          'manage_communications',
          'manage_documents',
          'manage_meetings',
          'view_reports',
        ];
      case UserRole.viceChairman:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'delete_news',
          'update_own_profile',
          'view_members',
          'approve_members',
          'reject_members',
          'manage_communications',
          'manage_documents',
          'manage_meetings',
          'manage_events',
          'assign_roles',
          'view_reports',
          'manage_subregion_representatives',
        ];
      case UserRole.chairman:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'delete_news',
          'update_own_profile',
          'view_members',
          'approve_members',
          'reject_members',
          'manage_communications',
          'manage_documents',
          'manage_meetings',
          'manage_events',
          'assign_roles',
          'revoke_roles',
          'manage_users',
          'view_reports',
          'full_admin_access',
          'manage_organization_settings',
        ];
      case UserRole.admin:
        return [
          'read_news',
          'create_news',
          'edit_news',
          'delete_news',
          'update_own_profile',
          'update_any_profile',
          'view_members',
          'approve_members',
          'reject_members',
          'manage_communications',
          'manage_documents',
          'manage_meetings',
          'manage_events',
          'assign_roles',
          'revoke_roles',
          'manage_users',
          'view_reports',
          'full_admin_access',
          'system_administration',
          'database_management',
          'backup_restore',
          'manage_app_settings',
        ];
    }
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  // Helper methods for common permission checks
  bool canAccessAdminPanel() => level >= 6;

  bool canModerateContent() => level >= 3;

  bool canViewSensitiveData() => level >= 4;

  bool canManageOrganization() => level >= 7;

  // Color coding for UI
  Color get color {
    switch (this) {
      case UserRole.member:
        return const Color(0xFF9E9E9E); // Grey
      case UserRole.subregionRepresentative:
        return const Color(0xFF4CAF50); // Green
      case UserRole.viceSecretary:
        return const Color(0xFF2196F3); // Blue
      case UserRole.accountant:
        return const Color(0xFFFF9800); // Orange
      case UserRole.secretary:
        return const Color(0xFF9C27B0); // Purple
      case UserRole.viceChairman:
        return const Color(0xFF3F51B5); // Indigo
      case UserRole.chairman:
        return const Color(0xFFF44336); // Red
      case UserRole.admin:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }

  // Icon representation for UI
  IconData get icon {
    switch (this) {
      case UserRole.member:
        return Icons.person;
      case UserRole.subregionRepresentative:
        return Icons.location_on;
      case UserRole.viceSecretary:
        return Icons.edit_note;
      case UserRole.accountant:
        return Icons.account_balance;
      case UserRole.secretary:
        return Icons.description;
      case UserRole.viceChairman:
        return Icons.supervisor_account;
      case UserRole.chairman:
        return Icons.star;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  // Sort roles by hierarchy level
  static List<UserRole> get sortedByLevel {
    final roles = UserRole.values.toList();
    roles.sort((a, b) => b.level.compareTo(a.level));
    return roles;
  }

  // Get roles that can be assigned by this role
  List<UserRole> get assignableRoles {
    if (this == UserRole.admin) return UserRole.values;
    if (level >= 7)
      return UserRole.values.where((role) => role.level < level).toList();
    if (level >= 6)
      return UserRole.values.where((role) => role.level <= 4).toList();
    return [];
  }

  // Check if this role can assign another role
  bool canAssignRole(UserRole targetRole) {
    return assignableRoles.contains(targetRole);
  }

  // Check if this role can revoke another role
  bool canRevokeRole(UserRole targetRole) {
    return canAssignRole(targetRole);
  }

  // the overide annotation below was commented out cause it was bringing an error
  @override
  String toStrisng() => label;
}
