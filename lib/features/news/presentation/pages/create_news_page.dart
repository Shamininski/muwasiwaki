// lib/features/news/presentation/pages/create_news_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/news_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Announcement';

  final List<String> _categories = [
    'Announcement',
    'Meeting',
    'Project',
    'Finance',
    'Event',
    'General',
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
          if (state is NewsLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('News article created successfully!')),
            );
            context.pop();
          } else if (state is NewsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Article Title *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Title is required' : null,
                  maxLength: 100,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content *',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 180),
                      child: Icon(Icons.article),
                    ),
                  ),
                  maxLines: 10,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Content is required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return ElevatedButton(
                            onPressed: () => _createNews(context, authState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667EEA),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Publish Article',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createNews(BuildContext context, AuthState authState) {
    if (_formKey.currentState?.validate() == true) {
      if (authState is AuthAuthenticated) {
        context.read<NewsBloc>().add(
              CreateNewsEvent(
                title: _titleController.text,
                content: _contentController.text,
                category: _selectedCategory,
                authorId: authState.user.id,
                authorName: authState.user.name,
              ),
            );
      }
    }
  }
}

// &&&&&&&&&&&&&&&&&&&&& CommentedOut on 17 DEC 2025 - 7subRegions &&&&&&&&&&&&&&&&&&&&
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../bloc/news_bloc.dart';
// import '../../../../shared/widgets/custom_text_field.dart';
// import '../../../../shared/widgets/custom_button.dart';
// import '../../../../core/utils/validation_utils.dart';

// class CreateNewsPage extends StatefulWidget {
//   const CreateNewsPage({super.key});

//   @override
//   State<CreateNewsPage> createState() => _CreateNewsPageState();
// }

// class _CreateNewsPageState extends State<CreateNewsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _contentController = TextEditingController();
//   String _selectedCategory = 'General';

//   final List<String> _categories = [
//     'General',
//     'Announcement',
//     'Meeting',
//     'Event',
//     'Achievement',
//     'News',
//     'Urgent',
//   ];

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create News Article'),
//         backgroundColor: const Color(0xFF667EEA),
//       ),
//       body: BlocListener<NewsBloc, NewsState>(
//         listener: (context, state) {
//           if (state is NewsCreated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             context.pop();
//           } else if (state is NewsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Article Details',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         CustomTextField(
//                           controller: _titleController,
//                           label: 'Title',
//                           isRequired: true,
//                           hint: 'Enter article title',
//                           validator: (value) =>
//                               ValidationUtils.validateRequired(value, 'Title'),
//                         ),
//                         const SizedBox(height: 16),
//                         DropdownButtonFormField<String>(
//                           value: _selectedCategory,
//                           decoration: const InputDecoration(
//                             labelText: 'Category *',
//                             border: OutlineInputBorder(),
//                           ),
//                           items: _categories.map((category) {
//                             return DropdownMenuItem(
//                               value: category,
//                               child: Text(category),
//                             );
//                           }).toList(),
//                           onChanged: (value) =>
//                               setState(() => _selectedCategory = value!),
//                         ),
//                         const SizedBox(height: 16),
//                         CustomTextField(
//                           controller: _contentController,
//                           label: 'Content',
//                           isRequired: true,
//                           hint: 'Write your article content here...',
//                           maxLines: 12,
//                           validator: (value) =>
//                               ValidationUtils.validateMinLength(
//                                   value, 20, 'Content'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 BlocBuilder<NewsBloc, NewsState>(
//                   builder: (context, state) {
//                     return CustomButton(
//                       text: 'PUBLISH ARTICLE',
//                       onPressed: state is NewsCreating ? null : _createArticle,
//                       isLoading: state is NewsCreating,
//                       isFullWidth: true,
//                       size: ButtonSize.large,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _createArticle() {
//     if (_formKey.currentState?.validate() == true) {
//       context.read<NewsBloc>().add(
//             CreateNewsEvent(
//               title: _titleController.text.trim(),
//               content: _contentController.text.trim(),
//               category: _selectedCategory,
//             ),
//           );
//     }
//   }
// }
