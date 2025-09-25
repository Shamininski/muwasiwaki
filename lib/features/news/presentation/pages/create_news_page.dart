// lib/features/news/presentation/pages/create_news_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/news_bloc.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/utils/validation_utils.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Announcement',
    'Meeting',
    'Event',
    'Achievement',
    'News',
    'Urgent',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News Article'),
        backgroundColor: const Color(0xFF667EEA),
      ),
      body: BlocListener<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is NewsError) {
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
                          'Article Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _titleController,
                          label: 'Title',
                          isRequired: true,
                          hint: 'Enter article title',
                          validator: (value) =>
                              ValidationUtils.validateRequired(value, 'Title'),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category *',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCategory = value!),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _contentController,
                          label: 'Content',
                          isRequired: true,
                          hint: 'Write your article content here...',
                          maxLines: 12,
                          validator: (value) =>
                              ValidationUtils.validateMinLength(
                                  value, 20, 'Content'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'PUBLISH ARTICLE',
                      onPressed: state is NewsCreating ? null : _createArticle,
                      isLoading: state is NewsCreating,
                      isFullWidth: true,
                      size: ButtonSize.large,
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

  void _createArticle() {
    if (_formKey.currentState?.validate() == true) {
      context.read<NewsBloc>().add(
            CreateNewsEvent(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              category: _selectedCategory,
            ),
          );
    }
  }
}
