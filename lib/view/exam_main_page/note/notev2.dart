import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_notes_model_all_list.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  RetrieveNotesModel? _notesModel;
  bool _isLoading = true;
  List<Map<String, String>> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotesData();
  }

  void _fetchNotesData() async {
    try {
      final baseRepo = BaseRepository();

      String url =
          '${KpatshalaRetrieveNotesQuestion.RetrieveNotesQuestion}?questionSetId=${widget.questionId}';

      final response = await baseRepo.getRequest(
        url,
        headers: null,
        context: context,
      );

      setState(() {
        _notesModel = RetrieveNotesModel.fromJson(response);

        if (_notesModel?.questionSetSolutions != null &&
            _notesModel!.questionSetSolutions!.isNotEmpty) {
          final videoLink =
              _notesModel!.questionSetSolutions!.first.videoLink ?? '';
          String? videoId = YoutubePlayer.convertUrlToId(videoLink);

          if (videoId != null) {
            _youtubeController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
            );
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  void _showNoteBottomSheet(
      {String? initialTitle, String? initialDescription, int? index}) {
    _titleController.text = initialTitle ?? '';
    _descriptionController.text = initialDescription ?? '';

    showCommonBottomSheet(
      context: context,
      height: MediaQuery.of(context).size.height * 0.6,
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 217, 217),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 15),
              customText("Create note", TextType.paragraphTitle, fontSize: 18),
              const SizedBox(height: 10),
              // Title TextField
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.87,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Note Title',
                    filled: true,
                    fillColor: const Color.fromRGBO(245, 247, 250, 1),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Description TextField
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.87,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  minLines: 6,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(245, 247, 250, 1),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.87,
          child: ElevatedButton(
            child: Text(index == null ? 'Add Note' : 'Edit Note'),
            onPressed: () {
              setState(() {
                if (index == null) {
                  // Adding a new note
                  notes.add({
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                  });
                } else {
                  // Editing an existing note
                  notes[index] = {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                  };
                }
              });
              Navigator.pop(context);
              _titleController.clear();
              _descriptionController.clear();
            },
          ),
        ),
      ],
      gradient: null,
      color: Colors.white,
    );
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
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
            ? const Center(
                child: CircularProgressIndicator()) // Loading Indicator
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _notesModel?.questionSetSolutions != null &&
                            _notesModel!.questionSetSolutions!.isNotEmpty
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
                      child: _notesModel?.questionNotes == null ||
                              _notesModel!.questionNotes!.isEmpty
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
                              itemCount: _notesModel!.questionNotes!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final note = _notesModel!.questionNotes![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColor.naturalGrey2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        note.title ?? '',
                                        TextType.paragraphTitleNormal,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        note.description ?? '',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double
                            .infinity, // Makes the button fill the available width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(135, 206, 235, 0.3)
                                    .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _showNoteBottomSheet();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColor.navyBlue,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Create a note",
                                  style: TextStyle(color: AppColor.navyBlue),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle overflow gracefully
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
