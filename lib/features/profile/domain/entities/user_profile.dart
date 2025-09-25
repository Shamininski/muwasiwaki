// lib/features/profile/domain/entities/user_profile.dart
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? district;
  final String? profession;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.district,
    this.profession,
    this.profileImageUrl,
    this.dateOfBirth,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        district,
        profession,
        profileImageUrl,
        dateOfBirth,
        bio,
        createdAt,
        updatedAt,
      ];

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? district,
    String? profession,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? bio,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      district: district ?? this.district,
      profession: profession ?? this.profession,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get hasProfileImage =>
      profileImageUrl != null && profileImageUrl!.isNotEmpty;

  bool get isComplete {
    return phoneNumber != null &&
        district != null &&
        profession != null &&
        bio != null &&
        dateOfBirth != null;
  }

  String get initials {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ').where((part) => part.isNotEmpty);
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    } else if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return 'U';
  }
}
