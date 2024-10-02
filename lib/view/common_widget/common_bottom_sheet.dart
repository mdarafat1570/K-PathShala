import 'package:flutter/material.dart';

void showCommonBottomSheet({
  required BuildContext context,
  required Widget content,
  required List<Widget> actions,
  LinearGradient? gradient,
  Color? color,
  double? height,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: height ?? MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null
              ? color
              : null,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          border: Border.all(width: 0.2, color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            if (actions.isNotEmpty)
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
