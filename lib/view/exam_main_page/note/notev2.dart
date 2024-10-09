import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
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
  final NoteRepository noteRepository = NoteRepository();
  late YoutubePlayerController _youtubeController;
  RetrieveNotesModel? _notesModel;
  List<QuestionNotes>? questionNotes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

 void _fetchNotes() async {
    await noteRepository.fetchNotes(widget.questionId, context);
    setState(() {
      _isLoading = false; 
    });
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
                    questionNotes != null && questionNotes!.isNotEmpty
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: YoutubePlayer(
                                controller: _youtubeController,
                                showVideoProgressIndicator: true,
                              ),
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
                                final note = questionNotes![
                                    index]; // Get the note object
                                return Card(
                                  margin: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                        note.title ?? ''), // Access note.title
                                    subtitle: Text(note.description ??
                                        ''), // Access note.description
                                    trailing: Text(
                                      note.createdAt != null
                                          ? DateTime.parse(note.createdAt!)
                                              .toLocal()
                                              .toString()
                                          : 'No date', // Format the date as needed
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          showAddNoteBottomSheet(context);
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
}
