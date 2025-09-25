// lib/features/roles/presentation/pages/role_assignment_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roles_bloc.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/custom_button.dart';

class RoleAssignmentPage extends StatefulWidget {
  final String userId;
  final String userName;

  const RoleAssignmentPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<RoleAssignmentPage> createState() => _RoleAssignmentPageState();
}

class _RoleAssignmentPageState extends State<RoleAssignmentPage> {
  String? _selectedRoleId;
  DateTime? _expirationDate;

  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(LoadRolesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Role to ${widget.userName}'),
        backgroundColor: const Color(0xFF667EEA),
      ),
      body: BlocConsumer<RolesBloc, RolesState>(
        listener: (context, state) {
          if (state is RoleAssigned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Role assigned successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is RolesLoading) {
            return const LoadingWidget(message: 'Loading roles...');
          } else if (state is RolesLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Role',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          state.roles.where((role) => role.isActive).length,
                      itemBuilder: (context, index) {
                        final activeRoles =
                            state.roles.where((role) => role.isActive).toList();
                        final role = activeRoles[index];
                        return RadioListTile<String>(
                          value: role.id,
                          groupValue: _selectedRoleId,
                          onChanged: (value) {
                            setState(() {
                              _selectedRoleId = value;
                            });
                          },
                          title: Text(role.name),
                          subtitle: Text(role.description),
                          activeColor: const Color(0xFF667EEA),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Expiration Date (Optional):'),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _selectExpirationDate,
                        child: Text(
                          _expirationDate != null
                              ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                              : 'Select Date',
                        ),
                      ),
                      if (_expirationDate != null)
                        IconButton(
                          onPressed: () =>
                              setState(() => _expirationDate = null),
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Assign Role',
                    onPressed: _selectedRoleId != null ? _assignRole : null,
                    isFullWidth: true,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _selectExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _expirationDate = date;
      });
    }
  }

  void _assignRole() {
    if (_selectedRoleId != null) {
      context.read<RolesBloc>().add(AssignRoleEvent(
            userId: widget.userId,
            roleId: _selectedRoleId!,
            expiresAt: _expirationDate,
          ));
    }
  }
}
