import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/notes_model/RetrieveNotebyIDModel.dart';
import 'package:kpathshala/model/notes_model/retrieve_notes_model_all_list.dart';
import 'package:kpathshala/repository/notes_Repository/notes_repository.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/exam_main_page/note/add_note_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteMainPage extends StatefulWidget {
  final int? questionId;
  final String? title;

  const NoteMainPage(this.questionId, this.title, {super.key});

  @override
  State<NoteMainPage> createState() => _NoteMainPageState();
}

class _NoteMainPageState extends State<NoteMainPage> {
  late YoutubePlayerController _youtubeController;
  NoteResultData? noteResultData;
  NoteGetModel? noteGet;
  List<QuestionNotes>? questionNotes;
  QuestionSetSolutions? questionSetSolutions;
  String? _titleError;
  String? _descriptionError;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    try {
      NoteRepository noteRepository = NoteRepository();
      NoteGetModel? noteData = await noteRepository.fetchNotes(
        questionSetId: widget.questionId!,
        context: context,
      );

      if (noteData != null) {
        noteGet = noteData;
        questionNotes = noteData.data?.questionNotes ?? [];
        questionSetSolutions = noteData.data?.questionSetSolutions;

        if (questionSetSolutions?.videoLink != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId:
                YoutubePlayer.convertUrlToId(questionSetSolutions!.videoLink!)!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              loop: false,
            ),
          );
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      log("Error fetching notes: ${e.toString()}"); // Handle the exception
      setState(() {
        _isLoading = false; // Ensure loading state is updated even on error
      });
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: CommonAppBar(title: widget.title ?? ""),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    questionSetSolutions?.videoLink != null
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // ignore: unnecessary_null_comparison
                              child: _youtubeController != null
                                  ? YoutubePlayer(
                                      controller: _youtubeController,
                                      showVideoProgressIndicator: true,
                                    )
                                  : const Center(
                                      child: Text("No Video Available")),
                            ),
                          )
                        : const Center(child: Text("No Video Available")),
                    const SizedBox(height: 15),
                    customText("Lesson Notes", TextType.subtitle, fontSize: 10),
                    const SizedBox(height: 10),
                    Expanded(
                      child: questionNotes == null || questionNotes!.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'No Notes Created',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Create notes for effective study and easier revisions',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: questionNotes!.length,
                              itemBuilder: (context, index) {
                                final note = questionNotes![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(
                                      10), // Add padding for better layout
                                  decoration: BoxDecoration(
                                    color: AppColor.naturalGrey2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: customText(
                                              note.title ?? '',
                                              TextType.paragraphTitleNormal,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _updateNoteDialog(
                                                      context,
                                                      note,
                                                      index); // Call update dialog
                                                },
                                                child: Container(
                                                    width: 53,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                                  26,
                                                                  35,
                                                                  126,
                                                                  0.2)
                                                              .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color:
                                                                Color.fromRGBO(
                                                                    100,
                                                                    100,
                                                                    100,
                                                                    1),
                                                            size: 8,
                                                          ),
                                                          Gap(5),
                                                          Text(
                                                            "Edit",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        100,
                                                                        100,
                                                                        100,
                                                                        1),
                                                                fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        title: const Column(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .info_outline,
                                                              size: 50,
                                                              color:  Color
                                                                  .fromARGB(255,
                                                                  139, 53, 47),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Confirmation',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: const Text(
                                                            'Are you sure you want to delete this note?'),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false); // Do not delete
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .grey100,
                                                                  // Cancel button color
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true); // Confirm delete
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          139,
                                                                          53,
                                                                          47),
                                                                  // Ok button color
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  // Check the confirmation result and handle note deletion
                                                  if (confirm == true) {
                                                    try {
                                                      await NoteRepository()
                                                          .deleteNote(note.id!,
                                                              context); // Delete the note
                                                      setState(() {
                                                        questionNotes!.removeAt(
                                                            index); // Remove note from list
                                                      });
                                                      noteGet = null;
                                                      questionNotes = null;
                                                      questionSetSolutions =
                                                          null;
                                                      _isLoading = false;
                                                      setState(() {});
                                                      _fetchNotes();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Note deleted successfully')),
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Failed to delete note: $e')),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: 24,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36),
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      customText(
                                        note.description ?? '',
                                        TextType.paragraphTitleNormal,
                                        fontSize: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await showAddNoteBottomSheet(
                                  context, widget.questionId!)
                              .then((value) {
                            if (value) {
                              noteGet = null;
                              questionNotes = null;
                              questionSetSolutions = null;
                              _isLoading = false;
                              setState(() {});
                              _fetchNotes();
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Colors.lightBlueAccent.withOpacity(0.3),
                          side: const BorderSide(color: Colors.blueAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: AppColor.navyBlue),
                            SizedBox(width: 8),
                            Text(
                              'Create a note',
                              style: TextStyle(
                                color: AppColor.navyBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }

  void _updateNoteDialog(BuildContext context, QuestionNotes note, int index) {
    TextEditingController titleController =
        TextEditingController(text: note.title);
    TextEditingController descriptionController =
        TextEditingController(text: note.description);
    bool isUpdating = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                  child: CustomTextField(
                    label: "Note Title",
                    controller: titleController,
                    errorMessage: _titleError,
                    maxLength: 100,
                    onChanged: (value) {
                      setState(() {
                        _titleError = null; // Clear error message on input
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                  child: CustomTextField(
                    label: "Description",
                    controller: descriptionController,
                    maxLines: 4,
                    errorMessage: _descriptionError,
                    onChanged: (value) {
                      setState(() {
                        _descriptionError = null; // Clear error message on input
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Do not delete
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.grey100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                isUpdating
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          if (titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty) {
                            final updatedNote = RetrieveNotebyIDUpdateModel(
                              id: note.id!,
                              title: titleController.text,
                              description: descriptionController.text,
                              questionSetId: widget.questionId!,
                            );

                            try {
                              isUpdating = true;
                              setState(() {});
                              await NoteRepository()
                                  .updateNote(updatedNote, context);

                              Navigator.pop(context); // Close the dialog.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Note updated successfully!')),
                              );
                              noteGet = null;
                              questionNotes = null;
                              questionSetSolutions = null;
                              _isLoading = false;
                              setState(() {});
                              _fetchNotes();
                            } catch (e) {
                              log('Error updating note: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to update note')),
                              );
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.navyBlue, // Ok button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
