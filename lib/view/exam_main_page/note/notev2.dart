import 'dart:developer';

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
  late YoutubePlayerController _youtubeController;
  NoteResultData? noteResultData;
  NoteGetModel? noteGet;
  List<QuestionNotes>? questionNotes;
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

      // Assuming that 'noteData.data?.videoUrl' contains the video URL.
      if (noteData != null) {
        noteGet = noteData;
        questionNotes = noteData.data?.questionNotes ?? [];

        // Initialize the YouTube controller if a video URL is available.
        if (noteData.data?.questionSetSolutions?.videoLink != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(
                noteData.data!.questionSetSolutions!.videoLink!)!,
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
                    questionNotes != null && questionNotes!.isNotEmpty
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
                                          customText(
                                            note.title ?? '',
                                            TextType.paragraphTitleNormal,
                                            fontSize: 12,
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // _showNoteBottomSheet(
                                                  //   initialTitle: notes[index]
                                                  //       ['title'],
                                                  //   initialDescription: notes[index]
                                                  //       ['description'],
                                                  //   index: index,
                                                  // );
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
                                              // Delete Container with Icon
                                              GestureDetector(
                                                onTap: () {
                                                  // _deleteNote(index);
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
                                              // ListTile(
                                              //   title: Text(note.title ?? ''),
                                              //   subtitle: Text(note.description ?? ''),
                                              //   trailing: Text(
                                              //     note.createdAt != null
                                              //         ? DateTime.parse(note.createdAt!)
                                              //             .toLocal()
                                              //             .toString()
                                              //         : 'No date',
                                              //   ),
                                              // ),
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
