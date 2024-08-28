import 'package:kpathshala/app_base/common_imports.dart';
// import 'package:kpathshala/view/login/registration_and_login_page.dart';

Widget BookDeshbordbuildCard() {
  return Container(
    padding: const EdgeInsets.all(10),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          "Ace the 2024 UBT Exam with K-Pathshala’s 100-Set Mock Test",
          TextType.title,
          color: AppColor.active,
          fontSize: 20,
        ),
        const Gap(5),
        const Row(
          children: [
            Text(
              'For only ৳999.00',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '৳1,500',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        commonCustomButton(
          width: 130,
          backgroundColor: const Color.fromARGB(233, 254, 152, 56),
          height: 40,
          borderRadius: 10,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const RegistrationPage(
            //       title: 'App',
            //     ),
            //   ),
            // );
          },
          reversePosition: true,
          child: customText(
            "View details",
            TextType.normal,
            color: AppColor.white,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
