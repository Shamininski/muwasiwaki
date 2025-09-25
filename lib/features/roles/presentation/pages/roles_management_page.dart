// lib/features/roles/presentation/pages/roles_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roles_bloc.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class RolesManagementPage extends StatefulWidget {
  const RolesManagementPage({super.key});

  @override
  State<RolesManagementPage> createState() => _RolesManagementPageState();
}

class _RolesManagementPageState extends State<RolesManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(LoadRolesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles Management'),
        backgroundColor: const Color(0xFF667EEA),
      ),
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state is RolesLoading) {
            return const LoadingWidget(message: 'Loading roles...');
          } else if (state is RolesLoaded) {
            if (state.roles.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Roles Found',
                message: 'No roles have been configured yet.',
                icon: Icons.admin_panel_settings,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.roles.length,
              itemBuilder: (context, index) {
                final role = state.roles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF667EEA),
                      child: Text(
                        role.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      role.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(role.description),
                        const SizedBox(height: 4),
                        Text(
                          'Level: ${role.level} • ${role.permissions.length} permissions',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: role.isActive ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role.isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is RolesError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<RolesBloc>().add(LoadRolesEvent()),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
