// lib/features/membership/presentation/pages/membership_application_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/membership_bloc.dart';
import '../../domain/entities/family_member.dart';
import '../widgets/family_member_form.dart';

class MembershipApplicationPage extends StatefulWidget {
  const MembershipApplicationPage({super.key});

  @override
  State<MembershipApplicationPage> createState() =>
      _MembershipApplicationPageState();
}

class _MembershipApplicationPageState extends State<MembershipApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _districtController = TextEditingController();
  final _professionController = TextEditingController();
  final _reasonController = TextEditingController();

  DateTime _dateOfEntry = DateTime.now();
  List<FamilyMember> _familyMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Application'),
        backgroundColor: const Color(0xFF667EEA),
      ),
      body: BlocListener<MembershipBloc, MembershipState>(
        listener: (context, state) {
          if (state is MembershipApplicationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Application submitted successfully!'),
              ),
            );
            Navigator.pop(context);
          } else if (state is MembershipError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                _buildDateOfEntrySection(),
                const SizedBox(height: 24),
                _buildFamilyMembersSection(),
                const SizedBox(height: 32),
                BlocBuilder<MembershipBloc, MembershipState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is MembershipLoading
                            ? null
                            : _submitApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667EEA),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is MembershipLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'SUBMIT APPLICATION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Email is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Phone is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(
                labelText: 'District *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'District is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _professionController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Joining',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateOfEntrySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of Entry',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDateOfEntry,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MMM dd, yyyy').format(_dateOfEntry)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Family Members',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addFamilyMember,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_familyMembers.isEmpty)
              const Text(
                'No family members added yet',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._familyMembers.asMap().entries.map((entry) {
                final index = entry.key;
                final member = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(member.name),
                    subtitle: Text(
                      '${member.relationship} • Born: ${DateFormat('MMM dd, yyyy').format(member.dateOfBirth)}',
                    ),
                    trailing: IconButton(
                      onPressed: () => _removeFamilyMember(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  void _selectDateOfEntry() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateOfEntry,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        _dateOfEntry = date;
      });
    }
  }

  void _addFamilyMember() {
    showDialog(
      context: context,
      builder: (context) => FamilyMemberForm(
        onSave: (member) {
          setState(() {
            _familyMembers.add(member);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _removeFamilyMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
    });
  }

  void _submitApplication() {
    if (_formKey.currentState?.validate() == true) {
      context.read<MembershipBloc>().add(
        SubmitApplicationEvent(
          applicantName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          district: _districtController.text,
          profession: _professionController.text,
          reasonForJoining: _reasonController.text,
          dateOfEntry: _dateOfEntry,
          familyMembers: _familyMembers,
        ),
      );
    }
  }
}
