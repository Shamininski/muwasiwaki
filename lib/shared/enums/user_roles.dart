// lib/shared/enums/user_role.dart
enum UserRole {
  member,
  chairman,
  viceChairman,
  secretary,
  viceSecretary,
  accountant,
  districtRepresentative,
  admin,
}

extension UserRoleExtension on UserRole {
  String get name {
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
      case UserRole.districtRepresentative:
        return 'District Representative';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get canApproveMembers {
    return this == UserRole.chairman ||
        this == UserRole.secretary ||
        this == UserRole.accountant ||
        this == UserRole.admin;
  }

  bool get canCreateNews {
    return this != UserRole.member;
  }
}
