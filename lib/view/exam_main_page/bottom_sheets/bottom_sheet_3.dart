import 'package:kpathshala/app_base/common_imports.dart';

Widget _bottomSheetType3(
    BuildContext context, String courseTitle, String courseDescription) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Requirements for $courseTitle',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          courseDescription,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
