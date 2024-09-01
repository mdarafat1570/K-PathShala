import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/Exam%20Main%20page/exam_list.dart';
import 'package:kpathshala/view/Exam%20Main%20page/iteam_list.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  void _showBottomSheet(BuildContext context, Widget bottomSheetContent) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return bottomSheetContent;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text("UBT Mock Test", style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 340,
                  height: 156,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F61),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                ),
                Expanded(
                  child: ExamListPage(
                    items: items,
                    showBottomSheet: _showBottomSheet,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define bottom sheet content widgets
class BottomSheetContent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is Bottom Sheet 1'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class BottomSheetContent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is Bottom Sheet 2'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class BottomSheetContent3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is Bottom Sheet 3'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class BottomSheetContent4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is Bottom Sheet 4'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
