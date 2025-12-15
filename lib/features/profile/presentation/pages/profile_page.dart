// lib/features/profile/presentation/pages/profile_page.dart (Fixed)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF667EEA),
        actions: [
          IconButton(
            onPressed: () => _showEditProfileDialog(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ProfileImageUploaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProfileInitial) {
                  context.read<ProfileBloc>().add(
                        LoadUserProfileEvent(userId: authState.user.id),
                      );
                  return const LoadingWidget(message: 'Loading profile...');
                } else if (state is ProfileLoading) {
                  return const LoadingWidget(message: 'Loading profile...');
                } else if (state is ProfileLoaded) {
                  return _ProfileContent(
                    profile: state.profile,
                    user: authState.user,
                  );
                } else if (state is ProfileError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<ProfileBloc>().add(
                          LoadUserProfileEvent(userId: authState.user.id),
                        ),
                  );
                }

                return const SizedBox();
              },
            );
          }
          return const Center(child: Text('User not authenticated'));
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing coming soon!')),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final dynamic profile; // UserProfile
  final dynamic user; // AppUser

  const _ProfileContent({required this.profile, required this.user});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(RefreshProfileEvent(userId: user.id));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Image with edit functionality
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              const Color(0xFF667EEA).withOpacity(0.1),
                          backgroundImage: profile.hasProfileImage
                              ? NetworkImage(profile.profileImageUrl!)
                              : null,
                          child: !profile.hasProfileImage
                              ? Text(
                                  profile.initials,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF667EEA),
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePickerDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF667EEA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      profile.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),

                    // User Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        user.role.name,
                        style: const TextStyle(
                          color: Color(0xFF667EEA),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Member since
                    Text(
                      'Member since ${AppDateUtils.formatDateReadable(user.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    // Profile completion indicator
                    const SizedBox(height: 16),
                    _buildProfileCompletionIndicator(profile),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Information Card
            _buildInfoCard(
              context,
              'Contact Information',
              [
                _InfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: profile.email,
                ),
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: profile.phoneNumber ?? 'Not provided',
                ),
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'District',
                  value: profile.district ?? 'Not provided',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Personal Information Card
            _buildInfoCard(
              context,
              'Personal Information',
              [
                _InfoRow(
                  icon: Icons.work,
                  label: 'Profession',
                  value: profile.profession ?? 'Not provided',
                ),
                if (profile.dateOfBirth != null)
                  _InfoRow(
                    icon: Icons.cake,
                    label: 'Date of Birth',
                    value:
                        AppDateUtils.formatDateReadable(profile.dateOfBirth!),
                  ),
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  _InfoRow(
                    icon: Icons.info,
                    label: 'Bio',
                    value: profile.bio!,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Actions Card
            _buildActionsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCompletionIndicator(dynamic profile) {
    final completion = _calculateProfileCompletion(profile);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Profile Completion',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              '${(completion * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF667EEA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: completion,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
        ),
      ],
    );
  }

  double _calculateProfileCompletion(dynamic profile) {
    int completed = 0;
    const int total = 6; // name, email, phone, district, profession, bio

    if (profile.name.isNotEmpty) completed++;
    if (profile.email.isNotEmpty) completed++;
    if (profile.phoneNumber != null) completed++;
    if (profile.district != null) completed++;
    if (profile.profession != null) completed++;
    if (profile.bio != null && profile.bio!.isNotEmpty) completed++;

    return completed / total;
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<_InfoRow> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...rows.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: row,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF667EEA)),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showEditProfileDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Color(0xFF667EEA)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showChangePasswordDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      context.read<ProfileBloc>().add(
            UploadProfileImageEvent(userId: user.id, image: imageFile),
          );
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing coming soon!')),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password feature coming soon!')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF667EEA),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
