import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/repository/notes_Repository/notes_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage(int questionId, {Key? key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final NoteRepository _notesRepository = NoteRepository();

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _questionSetId = 2; // Hardcoded for example. Adjust as per need.

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create a note object
        final note = RetrieveNotebyIDModel(
          id: null,
          questionSetId: _questionSetId,
          userId: null,
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: DateTime.now().toIso8601String(), // Set createdAt to now
          updatedAt: DateTime.now().toIso8601String(), // Set updatedAt to now
        );

        // Call the addNote function to submit the note
        await _notesRepository.addNote(note, context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note created successfully!')),
        );

        // Clear the form or navigate to another page if required
        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Create Note'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
