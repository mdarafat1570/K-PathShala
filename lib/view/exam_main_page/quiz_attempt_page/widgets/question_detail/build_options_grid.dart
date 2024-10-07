import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';

Widget buildOptionsGrid({
  required BuildContext context,
  required List<Options> options,
  required int selectedSolvedIndex,
  required Function(int, int) selectionHandling,
  required Function(BuildContext, String, Map<String, Uint8List>) showZoomedImage,
  required Map<String, Uint8List> cachedImages,
}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2,
    ),
    itemCount: options.length,
    itemBuilder: (context, index) {
      return _buildGridItem(
        context,
        options[index],
        index,
        selectedSolvedIndex,
        selectionHandling,
        showZoomedImage,
        cachedImages,
      );
    },
  );
}

Widget _buildGridItem(
    BuildContext context,
    Options option,
    int index,
    int selectedSolvedIndex,
    Function(int, int) selectionHandling,
    Function(BuildContext, String, Map<String, Uint8List>) showZoomedImage,
    Map<String, Uint8List> cachedImages,
    ) {
  String answerImage = option.imageUrl ?? "";
  int answerId = option.id ?? -1;

  return Padding(
    padding: const EdgeInsets.all(8),
    child: InkWell(
      onTap: () {
        selectionHandling(index, answerId);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOptionCircle(index, selectedSolvedIndex),
          const SizedBox(width: 8), // Spacing between circle and image
          if (answerImage.isNotEmpty)
            Expanded(
              child: InkWell(
                onTap: () {
                  showZoomedImage(context, answerImage, cachedImages);
                },
                child: _buildImage(answerImage, cachedImages),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildOptionCircle(int index, int selectedSolvedIndex) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: (selectedSolvedIndex == index) ? AppColor.black : Colors.white,
      shape: BoxShape.circle,
      border: Border.all(width: 2, color: AppColor.black),
    ),
    child: Center(
      child: Text(
        '${index + 1}',
        style: TextStyle(
          color: (selectedSolvedIndex == index) ? Colors.white : AppColor.black,
        ),
      ),
    ),
  );
}

Widget _buildImage(String imageUrl, Map<String, Uint8List> cachedImages) {
  return cachedImages.containsKey(imageUrl)
      ? Image.memory(
    cachedImages[imageUrl]!,
    fit: BoxFit.cover, // Ensure the image fits well in its container
  )
      : const Padding(
    padding: EdgeInsets.all(1.0),
    child: CircularProgressIndicator(),
  ); // Show loading if image is not yet cached
}
