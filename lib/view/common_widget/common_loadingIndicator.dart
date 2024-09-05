import 'package:flutter/material.dart';

class LoadingPopup extends StatelessWidget {
  const LoadingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.grey,
          ),
        ),
        Center(
          child:CircularProgressIndicator(),
        ),
      ],
    );
  }
}

Future<void> showLoadingIndicator({required BuildContext context, required bool showLoader}) async {
  return showLoader ? showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingPopup();
    },
  ) : Navigator.of(context, rootNavigator: true).pop();
}

