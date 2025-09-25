// lib/features/roles/presentation/widgets/role_assignment_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/roles_bloc.dart';
import '../../domain/entities/user_role.dart';
import '../../../../shared/widgets/custom_button.dart';

class RoleAssignmentForm extends StatefulWidget {
  final String userId;
  final String userName;
  final List<UserRoleEntity> availableRoles;
  final Function(String roleId, DateTime? expiresAt)? onAssign;

  const RoleAssignmentForm({
    super.key,
    required this.userId,
    required this.userName,
    required this.availableRoles,
    this.onAssign,
  });

  @override
  State<RoleAssignmentForm> createState() => _RoleAssignmentFormState();
}

class _RoleAssignmentFormState extends State<RoleAssignmentForm> {
  String? _selectedRoleId;
  DateTime? _expirationDate;
  bool _hasExpiration = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Assign Role to ${widget.userName}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Select Role:'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedRoleId,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            hint: const Text('Choose a role'),
            items: widget.availableRoles
                .where((role) => role.isActive)
                .map((role) => DropdownMenuItem<String>(
                      value: role.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            role.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedRoleId = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Set expiration date'),
          value: _hasExpiration,
          onChanged: (value) {
            setState(() {
              _hasExpiration = value ?? false;
              if (!_hasExpiration) {
                _expirationDate = null;
              }
            });
          },
          activeColor: const Color(0xFF667EEA),
          contentPadding: EdgeInsets.zero,
        ),
        if (_hasExpiration) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _expirationDate != null
                      ? 'Expires: ${DateFormat('MMM dd, yyyy').format(_expirationDate!)}'
                      : 'Select expiration date',
                ),
              ),
              TextButton(
                onPressed: _selectExpirationDate,
                child: const Text('Select Date'),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        CustomButton(
          text: 'Assign Role',
          onPressed: _selectedRoleId != null ? _onAssignRole : null,
          isFullWidth: true,
        ),
      ],
    );
  }

  void _selectExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _expirationDate = date;
      });
    }
  }

  void _onAssignRole() {
    if (_selectedRoleId != null) {
      if (widget.onAssign != null) {
        widget.onAssign!(_selectedRoleId!, _expirationDate);
      } else {
        context.read<RolesBloc>().add(AssignRoleEvent(
              userId: widget.userId,
              roleId: _selectedRoleId!,
              expiresAt: _expirationDate,
            ));
      }
    }
  }
}
