// lib/features/profile/presentation/pages/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/profile_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/utils/validation_utils.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _districtController;
  late final TextEditingController _professionController;
  late final TextEditingController _bioController;
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController =
        TextEditingController(text: widget.profile.phoneNumber ?? '');
    _districtController =
        TextEditingController(text: widget.profile.district ?? '');
    _professionController =
        TextEditingController(text: widget.profile.profession ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _dateOfBirth = widget.profile.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF667EEA),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          isRequired: true,
                          validator: ValidationUtils.validateName,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value?.isNotEmpty == true) {
                              return ValidationUtils.validatePhone(value);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _districtController,
                          label: 'District',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _professionController,
                          label: 'Profession',
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _selectDateOfBirth,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dateOfBirth != null
                                      ? 'Date of Birth: ${DateFormat('MMM dd, yyyy').format(_dateOfBirth!)}'
                                      : 'Select Date of Birth',
                                  style: TextStyle(
                                    color: _dateOfBirth != null
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _bioController,
                          label: 'Bio',
                          maxLines: 4,
                          hint: 'Tell us about yourself...',
                          validator: (value) =>
                              ValidationUtils.validateMaxLength(
                            value,
                            500,
                            'Bio',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Update Profile',
                      onPressed:
                          state is ProfileLoading ? null : _updateProfile,
                      isLoading: state is ProfileLoading,
                      isFullWidth: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDateOfBirth() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dateOfBirth = date;
      });
    }
  }

  void _updateProfile() {
    if (_formKey.currentState?.validate() == true) {
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        district: _districtController.text.trim().isEmpty
            ? null
            : _districtController.text.trim(),
        profession: _professionController.text.trim().isEmpty
            ? null
            : _professionController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        dateOfBirth: _dateOfBirth,
        updatedAt: DateTime.now(),
      );

      context
          .read<ProfileBloc>()
          .add(UpdateUserProfileEvent(profile: updatedProfile));
    }
  }
}
