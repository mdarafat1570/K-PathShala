import 'package:kpathshala/authentication/base_repository.dart';

import '../../app_base/common_imports.dart';

class DeviceIdBottomSheet extends StatefulWidget {
  const DeviceIdBottomSheet({super.key});

  @override
  State<DeviceIdBottomSheet> createState() => _DeviceIdBottomSheetState();
}

class _DeviceIdBottomSheetState extends State<DeviceIdBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top indicator
          const Gap(5),
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
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  BaseRepository().userSignOut(context);
                },
                child:  customText("Log out",TextType.normal,color: AppColor.white,fontSize: 18),
              )),
          const Gap(30),
        ],
      ),
    );
  }
}
