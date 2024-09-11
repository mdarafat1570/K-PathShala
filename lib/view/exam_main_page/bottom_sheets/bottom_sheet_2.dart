import 'package:kpathshala/app_base/common_imports.dart';

Widget bottomSheetType2(
    BuildContext context, String courseTitle, String courseDescription) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          courseTitle,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        commonCustomButton(
            width: 320,
            backgroundColor: const Color.fromRGBO(136, 208, 236, 0.2),
            height: 67,
            borderRadius: 20,
            onPressed: () {},
            reversePosition: false,
            child: const Text(
              "Solve video",
              style: TextStyle(color: AppColor.navyBlue),
            ))
      ],
    ),
  );
}
