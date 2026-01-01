// lib/shared/enums/user_role.dart (Fixed - No Extension Needed)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../../../../shared/enums/user_role.dart';

enum UserRole {
  member,
  chairman,
  viceChairman,
  secretary,
  viceSecretary,
  accountant,
  subregionRepresentative,
  admin;

  // Get the display label
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

  String toStorageString() {
    return 'UserRole.$name';
  }

  static UserRole fromStorageString(String value) {
    return UserRole.values.firstWhere(
      (role) =>
          'UserRole.${role.name}' == value ||
          role.name == value.replaceAll('UserRole.', ''),
      orElse: () => UserRole.member,
    );
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
}

// // lib/features/profile/presentation/pages/profile_page.dart (Fixed)
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../core/utils/date_utils.dart';
// import '../../../../shared/widgets/error_widget.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../../auth/presentation/bloc/auth_bloc.dart';
// import '../bloc/profile_bloc.dart';
// import '../../../../shared/enums/user_role.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: const Color(0xFF667EEA),
//         actions: [
//           IconButton(
//             onPressed: () => _showEditProfileDialog(context),
//             icon: const Icon(Icons.edit),
//           ),
//         ],
//       ),
//       body: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, authState) {
//           if (authState is AuthAuthenticated) {
//             return BlocConsumer<ProfileBloc, ProfileState>(
//               listener: (context, state) {
//                 if (state is ProfileError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.message),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 } else if (state is ProfileUpdated) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.message),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 } else if (state is ProfileImageUploaded) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.message),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ProfileInitial) {
//                   context.read<ProfileBloc>().add(
//                         LoadUserProfileEvent(userId: authState.user.id),
//                       );
//                   return const LoadingWidget(message: 'Loading profile...');
//                 } else if (state is ProfileLoading) {
//                   return const LoadingWidget(message: 'Loading profile...');
//                 } else if (state is ProfileLoaded) {
//                   return _ProfileContent(
//                     profile: state.profile,
//                     user: authState.user,
//                   );
//                 } else if (state is ProfileError) {
//                   return CustomErrorWidget(
//                     message: state.message,
//                     onRetry: () => context.read<ProfileBloc>().add(
//                           LoadUserProfileEvent(userId: authState.user.id),
//                         ),
//                   );
//                 }

//                 return const SizedBox();
//               },
//             );
//           }
//           return const Center(child: Text('User not authenticated'));
//         },
//       ),
//     );
//   }

//   void _showEditProfileDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile editing coming soon!')),
//     );
//   }
// }

// class _ProfileContent extends StatelessWidget {
//   final dynamic profile; // UserProfile
//   final dynamic user; // AppUser

//   const _ProfileContent({required this.profile, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<ProfileBloc>().add(RefreshProfileEvent(userId: user.id));
//       },
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile Header Card
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   children: [
//                     // Profile Image with edit functionality
//                     Stack(
//                       alignment: Alignment.bottomRight,
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor:
//                               const Color(0xFF667EEA).withOpacity(0.1),
//                           backgroundImage: profile.hasProfileImage
//                               ? NetworkImage(profile.profileImageUrl!)
//                               : null,
//                           child: !profile.hasProfileImage
//                               ? Text(
//                                   profile.initials,
//                                   style: const TextStyle(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF667EEA),
//                                   ),
//                                 )
//                               : null,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: GestureDetector(
//                             onTap: () => _showImagePickerDialog(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFF667EEA),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 size: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // User Name
//                     Text(
//                       profile.name,
//                       style:
//                           Theme.of(context).textTheme.headlineMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                     ),
//                     const SizedBox(height: 4),

//                     // User Role Badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF667EEA).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                         user.role.label,
//                         style: const TextStyle(
//                           color: Color(0xFF667EEA),
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Member since
//                     Text(
//                       'Member since ${AppDateUtils.formatDateReadable(user.createdAt)}',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),

//                     // Profile completion indicator
//                     const SizedBox(height: 16),
//                     _buildProfileCompletionIndicator(profile),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Contact Information Card
//             _buildInfoCard(
//               context,
//               'Contact Information',
//               [
//                 _InfoRow(
//                   icon: Icons.email,
//                   label: 'Email',
//                   value: profile.email,
//                 ),
//                 _InfoRow(
//                   icon: Icons.phone,
//                   label: 'Phone',
//                   value: profile.phoneNumber ?? 'Not provided',
//                 ),
//                 _InfoRow(
//                   icon: Icons.location_on,
//                   label: 'Subregion',
//                   value: profile.subregion ?? 'Not provided',
//                 ),
//                 _InfoRow(
//                   icon: Icons.location_on,
//                   label: 'nidaNumber',
//                   value: profile.nidaNumber ?? 'Not provided',
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Personal Information Card
//             _buildInfoCard(
//               context,
//               'Personal Information',
//               [
//                 _InfoRow(
//                   icon: Icons.work,
//                   label: 'Profession',
//                   value: profile.profession ?? 'Not provided',
//                 ),
//                 if (profile.dateOfBirth != null)
//                   _InfoRow(
//                     icon: Icons.cake,
//                     label: 'Date of Birth',
//                     value:
//                         AppDateUtils.formatDateReadable(profile.dateOfBirth!),
//                   ),
//                 if (profile.bio != null && profile.bio!.isNotEmpty)
//                   _InfoRow(
//                     icon: Icons.info,
//                     label: 'Bio',
//                     value: profile.bio!,
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Actions Card
//             _buildActionsCard(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCompletionIndicator(dynamic profile) {
//     final completion = _calculateProfileCompletion(profile);
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Profile Completion',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//             Text(
//               '${(completion * 100).toInt()}%',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF667EEA),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: completion,
//           backgroundColor: Colors.grey[300],
//           valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
//         ),
//       ],
//     );
//   }

//   double _calculateProfileCompletion(dynamic profile) {
//     int completed = 0;
//     const int total =
//         7; // name, email, phone, subregion, profession, nidaNumber, bio

//     if (profile.name.isNotEmpty) completed++;
//     if (profile.email.isNotEmpty) completed++;
//     if (profile.phoneNumber != null) completed++;
//     if (profile.subregion != null) completed++;
//     if (profile.profession != null) completed++;
//     if (profile.nidaNumber != null) completed++;
//     if (profile.bio != null && profile.bio!.isNotEmpty) completed++;

//     return completed / total;
//   }

//   Widget _buildInfoCard(
//       BuildContext context, String title, List<_InfoRow> rows) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             ...rows.map((row) => Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: row,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionsCard(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Actions',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.edit, color: Color(0xFF667EEA)),
//               title: const Text('Edit Profile'),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () => _showEditProfileDialog(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.security, color: Color(0xFF667EEA)),
//               title: const Text('Change Password'),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () => _showChangePasswordDialog(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Logout'),
//               onTap: () => _showLogoutDialog(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showImagePickerDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_camera),
//               title: const Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(context, ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(context, ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _pickImage(BuildContext context, ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       final imageFile = File(pickedFile.path);
//       context.read<ProfileBloc>().add(
//             UploadProfileImageEvent(userId: user.id, image: imageFile),
//           );
//     }
//   }

//   void _showEditProfileDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile editing coming soon!')),
//     );
//   }

//   void _showChangePasswordDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Change password feature coming soon!')),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 context.read<AuthBloc>().add(LogoutEvent());
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: const Color(0xFF667EEA),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
