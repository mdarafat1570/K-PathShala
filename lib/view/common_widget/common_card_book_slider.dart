import 'package:kpathshala/app_base/common_imports.dart';

Widget BookDeshbordbuildCard() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColor.gradientStart,
              AppColor.gradient,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: customText(
                  "Ace the 2024 UBT Exam with \nK-Pathshala’s 100-Set Mock Test",
                  TextType.title,
                  color: AppColor.active,
                  fontSize: 20,
                ),
              ),
              const Gap(5),
              const Row(
                children: [
                  Flexible(
                    child: Text(
                      'For only ৳999.00',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '৳1,500',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: commonCustomButton(
                  width: constraints.maxWidth * 0.4,
                  backgroundColor: const Color(0xFFFF6F61),
                  height: 40,
                  borderRadius: 10,
                  onPressed: () {},
                  reversePosition: true,
                  child: customText(
                    "View details",
                    TextType.normal,
                    color: AppColor.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
