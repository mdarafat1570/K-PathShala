import 'package:flutter/material.dart';

void showCommonBottomSheet({
  required BuildContext context,
  required Widget content,
  required List<Widget> actions,
  Color? color, // Optional color parameter
  double? height, // Optional height parameter
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    backgroundColor:
        color ?? Colors.white, // Use provided color or default to white
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: height ??
              MediaQuery.of(context).size.height *
                  0.6, // Default height if none provided
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.black),
          color: const Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
          ],
        ),
      );
    },
  );
}
