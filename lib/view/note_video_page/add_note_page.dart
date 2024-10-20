import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/repository/notes_Repository/notes_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';
import 'package:kpathshala/view/common_widget/custom_textfield.dart';

Future<bool> showAddNoteBottomSheet(
    BuildContext context,
    int questionSetId,
    ) async {
  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return AddNoteBottomSheetContent(questionSetId: questionSetId);
    },
  ) ?? false; // Return false if null
}


class AddNoteBottomSheetContent extends StatefulWidget {
  final int questionSetId; // Add this line

  const AddNoteBottomSheetContent({super.key, required this.questionSetId});

  @override
  AddNoteBottomSheetContentState createState() =>
      AddNoteBottomSheetContentState();
}

class AddNoteBottomSheetContentState extends State<AddNoteBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final NoteRepository _notesRepository = NoteRepository();

  // Controllers for title and description fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _titleError;
  String? _descriptionError;

  bool _isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      _titleError = _titleController.text.isEmpty
          ? "Title is required"
          : _titleController.text.length > 255
              ? "Title must be less than 255 characters"
              : null;

      _descriptionError = _descriptionController.text.isEmpty
          ? "Description is required"
          : null;

      if (_titleError == null && _descriptionError == null) {
        _isLoading = true;
      }
    });

    if (_titleError == null && _descriptionError == null) {
      try {
        final note = RetrieveNotebyIDModel(
          id: null,
          questionSetId: widget.questionSetId,
          userId: null,
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );

        await _notesRepository.addNote(note, context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully!')),
        );

        Navigator.of(context).pop(true);
      } catch (e) {
        // Show error message
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // To handle keyboard overflow
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 80,
                  color: AppColor.grey100,
                ),
              ),
              const Gap(10),
              const Center(
                child: Text(
                  'Add Note',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color:  Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
                child: CustomTextField(
                  label: "Note Title",
                  controller: _titleController,
                  errorMessage: _titleError,
                  maxLength: 100,
                  onChanged: (value) {
                    setState(() {
                      _titleError = null;
                    });
                  },
                ),
              ),
              const Gap(16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color:  Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
                child: CustomTextField(
                  label: "Description",
                  controller: _descriptionController,
                  maxLines: 4,
                  errorMessage: _descriptionError,
                  onChanged: (value) {
                    setState(() {
                      _descriptionError = null;
                    });
                  },
                ),
              ),
              const Gap(24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: SizedBox(
                      width: 400,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Save Note'),
                      ),
                    )),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
