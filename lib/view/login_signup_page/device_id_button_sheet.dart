import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top indicator
          Container(
            width: screenWidth * 0.2,
            height: screenHeight * 0.005,
            decoration: BoxDecoration(
              color: AppColor.notBillable,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Gap(35),
          // Error icon
          Image.asset(
            "assets/reject.png",
            height: 100,
            width: 100,
          ),
          const Gap(20),
          // Centered Text with Padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: 340,
              child: customText(
                "You can’t use one K-Pathshala App account in more than 2 devices.",
                TextType.normal,
                textAlign: TextAlign.center,  
              ),
            ),
          ),
          const Gap(30),
         SizedBox(
              height: 54,
              width: 340,
              child: ElevatedButton(
                onPressed: () {},
                child:  customText("Log out",TextType.normal,color: AppColor.white,fontSize: 18),
              )),
        ],
      ),
    );
  }
}
