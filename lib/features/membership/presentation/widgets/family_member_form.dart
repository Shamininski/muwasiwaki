// lib/features/membership/presentation/widgets/family_member_form.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/family_member.dart';

class FamilyMemberForm extends StatefulWidget {

  const FamilyMemberForm({super.key, required this.onSave});
  final Function(FamilyMember) onSave;

  @override
  State<FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _relationship = 'wife';
  DateTime _dateOfBirth =
      DateTime.now().subtract(const Duration(days: 365 * 25));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Family Member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) =>
                  value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _relationship,
              decoration: const InputDecoration(
                labelText: 'Relationship *',
                border: OutlineInputBorder(),
              ),
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(value: 'wife', child: Text('Wife')),
                DropdownMenuItem(value: 'husband', child: Text('Husband')),
                DropdownMenuItem(value: 'child', child: Text('Child')),
              ],
              onChanged: (String? value) => setState(() => _relationship = value!),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDateOfBirth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        'Born: ${DateFormat('MMM dd, yyyy').format(_dateOfBirth)}'),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveFamilyMember,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _selectDateOfBirth() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dateOfBirth = date;
      });
    }
  }

  void _saveFamilyMember() {
    if (_formKey.currentState?.validate() == true) {
      widget.onSave(FamilyMember(
        name: _nameController.text,
        dateOfBirth: _dateOfBirth,
        relationship: _relationship,
      ));
    }
  }
}
