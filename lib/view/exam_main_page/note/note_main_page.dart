import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/exam_main_page/note/add_note_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Note extends StatefulWidget {
  const Note(int questionId, String title, {super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  List<Map<String, String>> notes = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    const String youtubeUrl =
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ'; // Replace with your YouTube link
    String? videoId = YoutubePlayer.convertUrlToId(
        youtubeUrl); // Convert the link to video ID

    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      throw Exception('Invalid YouTube URL: $youtubeUrl');
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // // Function to show bottom sheet for adding or editing a note
  // void _showNoteBottomSheet(
  //     {String? initialTitle, String? initialDescription, int? index}) {
  //   _titleController.text = initialTitle ?? '';
  //   _descriptionController.text = initialDescription ?? '';

  //   showCommonBottomSheet(
  //     context: context,
  //     height: MediaQuery.of(context).size.height * 0.6,
  //     content: Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Center(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               width: 60,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: const Color.fromARGB(255, 217, 217, 217),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             customText("Create note", TextType.paragraphTitle, fontSize: 18),
  //             const SizedBox(height: 10),
  //             // Title TextField
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.87,
  //               child: TextField(
  //                 controller: _titleController,
  //                 decoration: InputDecoration(
  //                   labelText: 'Note Title',
  //                   filled: true,
  //                   fillColor: const Color.fromRGBO(245, 247, 250, 1),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderSide:
  //                         const BorderSide(color: Colors.grey, width: 1.0),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             // Description TextField
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.87,
  //               child: TextField(
  //                 controller: _descriptionController,
  //                 maxLines: null,
  //                 minLines: 6,
  //                 decoration: InputDecoration(
  //                   filled: true,
  //                   fillColor: const Color.fromRGBO(245, 247, 250, 1),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderSide:
  //                         const BorderSide(color: Colors.grey, width: 1.0),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   contentPadding: const EdgeInsets.symmetric(
  //                       vertical: 10, horizontal: 10),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //           ],
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       SizedBox(
  //         width: MediaQuery.of(context).size.width * 0.87,
  //         child: ElevatedButton(
  //           child: Text(index == null ? 'Add Note' : 'Edit Note'),
  //           onPressed: () {
  //             setState(() {
  //               if (index == null) {
  //                 // Adding a new note
  //                 notes.add({
  //                   'title': _titleController.text,
  //                   'description': _descriptionController.text,
  //                 });
  //               } else {
  //                 // Editing an existing note
  //                 notes[index] = {
  //                   'title': _titleController.text,
  //                   'description': _descriptionController.text,
  //                 };
  //               }
  //             });
  //             Navigator.pop(context);
  //             _titleController.clear();
  //             _descriptionController.clear();
  //           },
  //         ),
  //       ),
  //     ],
  //     gradient: null,
  //     color: Colors.white,
  //   );
  // }

  // Function to delete a note
  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: const CommonAppBar(title: "EPS TOPIK Set 02 solve"),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
                    onReady: () {
                      // You can add additional functionality when the player is ready
                    },
                  ),
                ),
              ),
              const Gap(15),
              customText("Lesson Notes", TextType.subtitle, fontSize: 10),
              const Gap(10),
              Expanded(
                child: notes.isEmpty
                    ? const Center(
                        child: Text(
                            "There will be no notes.")) // Message when no notes exist
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(
                                10), // Add padding for better layout
                            decoration: BoxDecoration(
                              color: AppColor.naturalGrey2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText(
                                      notes[index]['title'] ?? '',
                                      TextType.paragraphTitleNormal,
                                      fontSize: 12,
                                    ),
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
                                                color: const Color.fromRGBO(
                                                        26, 35, 126, 0.2)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      color: Color.fromRGBO(
                                                          100, 100, 100, 1),
                                                      size: 8,
                                                    ),
                                                    Gap(5),
                                                    Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              100, 100, 100, 1),
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
                                            _deleteNote(index);
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(36),
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notes[index]['description'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  maxLines:
                                      null, // Allows the description to take multiple lines
                                  overflow: TextOverflow
                                      .visible, // Remove ellipsis to display full content
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
                  width: MediaQuery.of(context).size.width * 0.87,
                  height: 39,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(135, 206, 235, 0.3)
                          .withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showAddNoteBottomSheet(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColor.navyBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Create a note",
                          style: TextStyle(color: AppColor.navyBlue),
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
