import 'package:flutter/material.dart';
import 'dart:typed_data';

void showZoomedImage(BuildContext context, String imageUrl, Map<String, Uint8List> cachedImages) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: cachedImages.containsKey(imageUrl)
                ? Image.memory(
              cachedImages[imageUrl]!,
              fit: BoxFit.fitWidth,
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    },
  );
}
