import '../../app_base/common_imports.dart';

class DevoiceIdButtonSheet extends StatefulWidget {
  const DevoiceIdButtonSheet({super.key});

  @override
  State<DevoiceIdButtonSheet> createState() => _DevoiceIdButtonSheetState();
}

class _DevoiceIdButtonSheetState extends State<DevoiceIdButtonSheet> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      // Center everything horizontally
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Aligns everything from the start
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns content in the center
        children: [
          Container(
            width: screenWidth * 0.2, // 20% of screen width
            height: screenHeight *
                0.005, // Adjust the height (thickness) for responsiveness
            decoration: BoxDecoration(
              color: AppColor.notBillable,
              borderRadius: BorderRadius.circular(8), // Circular edges
            ),
          ),
          const Gap(35),
          Image.asset(
            "assets/uncheck_mark.PNG",
            height: 67,
            width: 67,
          ),
          const Gap(20),
          const SizedBox(
            width: 340,
            height: 54,
            child: Text(
                "You can’t use one K-Pathshala App account in more then 2 devices."),
          ),
          const Gap(30),
          SizedBox(
              height: 54,
              width: 340,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Log out"),
              ))
        ],
      ),
    );
  }
}
