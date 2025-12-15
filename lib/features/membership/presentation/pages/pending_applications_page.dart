// lib/features/membership/presentation/pages/pending_applications_page.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/membership_bloc.dart';
import '../../domain/entities/membership_application.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../core/utils/date_utils.dart';

class PendingApplicationsPage extends StatefulWidget {
  const PendingApplicationsPage({super.key});

  @override
  State<PendingApplicationsPage> createState() =>
      _PendingApplicationsPageState();
}

class _PendingApplicationsPageState extends State<PendingApplicationsPage> {
  @override
  void initState() {
    super.initState();
    // Load applications when page initializes
    context.read<MembershipBloc>().add(LoadApplicationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Applications'),
        backgroundColor: const Color(0xFF667EEA),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<MembershipBloc>().add(RefreshApplicationsEvent()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocConsumer<MembershipBloc, MembershipState>(
        listener: (context, state) {
          if (state is MembershipActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is MembershipError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MembershipLoading) {
            return const LoadingWidget(message: 'Loading applications...');
          } else if (state is ApplicationsLoaded) {
            if (state.applications.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Applications',
                message:
                    'There are no membership applications to review at this time.',
                icon: Icons.inbox_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MembershipBloc>().add(RefreshApplicationsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.applications.length,
                itemBuilder: (context, index) {
                  final application = state.applications[index];
                  return _ApplicationCard(
                    application: application,
                    onApprove: () =>
                        _showApprovalDialog(context, application.id, true),
                    onReject: () =>
                        _showApprovalDialog(context, application.id, false),
                  );
                },
              ),
            );
          } else if (state is MembershipError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<MembershipBloc>().add(LoadApplicationsEvent()),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showApprovalDialog(
      BuildContext context, String applicationId, bool approve) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${approve ? 'Approve' : 'Reject'} Application'),
        content: Text(
            'Are you sure you want to ${approve ? 'approve' : 'reject'} this membership application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (approve) {
                context
                    .read<MembershipBloc>()
                    .add(ApproveApplicationEvent(applicationId));
              } else {
                context
                    .read<MembershipBloc>()
                    .add(RejectApplicationEvent(applicationId));
              }
            },
            child: Text(
              approve ? 'Approve' : 'Reject',
              style: TextStyle(
                color: approve ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final MembershipApplication application;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApplicationCard({
    required this.application,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getStatusColor(application.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          application.applicantName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${application.district} • Applied ${AppDateUtils.getRelativeTime(application.createdAt)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(application.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                application.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(application.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailSection('Contact Information', [
                  _DetailRow('Email', application.email),
                  _DetailRow('Phone', application.phone),
                ]),
                const SizedBox(height: 16),
                _buildDetailSection('Personal Information', [
                  _DetailRow('Profession', application.profession),
                  _DetailRow('Date of Entry',
                      AppDateUtils.formatDateReadable(application.dateOfEntry)),
                ]),
                if (application.familyMembers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Family Members', []),
                  const SizedBox(height: 8),
                  ...application.familyMembers.map((member) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                member.relationship == 'child'
                                    ? Icons.child_care
                                    : Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${member.relationship.capitalize()} • Born ${AppDateUtils.formatDateReadable(member.dateOfBirth)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
                if (application.status == ApplicationStatus.pending) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('APPROVE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.cancel),
                          label: const Text('REJECT'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (application.reviewedBy != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          application.status == ApplicationStatus.approved
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _getStatusColor(application.status),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${application.status.name.capitalize()} by admin on ${AppDateUtils.formatDateReadable(application.reviewedAt!)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<_DetailRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...rows.map((row) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      '${row.label}:',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }
}

class _DetailRow {
  final String label;
  final String value;

  _DetailRow(this.label, this.value);
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
