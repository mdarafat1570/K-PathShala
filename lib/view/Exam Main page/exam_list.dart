import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/Exam%20Main%20page/exam.dart';
import 'package:kpathshala/view/Exam%20Main%20page/iteam_list.dart';

class ExamListPage extends StatefulWidget {
  final List<Item> items;
  final Function(BuildContext, Widget) showBottomSheet;

  const ExamListPage({
    Key? key,
    required this.items,
    required this.showBottomSheet,
  }) : super(key: key);

  @override
  _ExamListPageState createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  int? _selectedIndex; // Variable to keep track of selected item
  int _count = 0; // Variable to keep track of tests taken

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = _selectedIndex == index;
        final scoreTextColor =
            item.score == 40 ? AppColor.navyBlue : Colors.red;
        final containerColor = isSelected
            ? Color.fromRGBO(135, 206, 235, 0.2)
            : Color.fromRGBO(
                245, 247, 250, 1); // Container color based on selection
        String testTakenText = item.count > 0 ? 'Retake Test' : 'Start';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = isSelected ? null : index; // Toggle selection
              });
              switch (index) {
                case 0:
                  widget.showBottomSheet(context, BottomSheetContent1());
                  break;
                case 1:
                  widget.showBottomSheet(context, BottomSheetContent2());
                  break;
                case 2:
                  widget.showBottomSheet(context, BottomSheetContent3());
                  break;
                case 3:
                  widget.showBottomSheet(context, BottomSheetContent4());
                  break;
              }
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: containerColor, // Set container color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      customText(item.title, TextType.paragraphTitlenormal),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  customText(item.description, TextType.normal),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      customText('Your score: ', TextType.normal),
                      Text(
                        '${item.score}', // Display the score
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: scoreTextColor, // Use dynamic score text color
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            item.count++;
                          });
                          switch (index) {
                            case 0:
                              widget.showBottomSheet(
                                  context, BottomSheetContent1());
                              break;
                            case 1:
                              widget.showBottomSheet(
                                  context, BottomSheetContent2());
                              break;
                            case 2:
                              widget.showBottomSheet(
                                  context, BottomSheetContent3());
                              break;
                            case 3:
                              widget.showBottomSheet(
                                  context, BottomSheetContent4());
                              break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.navyBlue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                        child: Text(testTakenText),
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          switch (index) {
                            case 0:
                              widget.showBottomSheet(
                                  context, BottomSheetContent1());
                              break;
                            case 1:
                              widget.showBottomSheet(
                                  context, BottomSheetContent2());
                              break;
                            case 2:
                              widget.showBottomSheet(
                                  context, BottomSheetContent3());
                              break;
                            case 3:
                              widget.showBottomSheet(
                                  context, BottomSheetContent4());
                              break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.navyBlue,
                          backgroundColor: Color.fromRGBO(26, 35, 126, 0.2),
                          shape: CircleBorder(), // Make the button round
                          padding: EdgeInsets.all(12), // Icon color
                          shadowColor: Colors.transparent, // Remove shadow
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.arrowDown,
                          size: 16,
                          color: AppColor.navyBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
