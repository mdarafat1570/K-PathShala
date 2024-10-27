import 'package:kpathshala/app_base/common_imports.dart';

class PaymentRow extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final VoidCallback onTap;
  final String imageUrl;
  const PaymentRow({
    required this.title,
    required this.amount,
    required this.date,
    required this.onTap,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: FadeInImage.assetNetwork(
                placeholder: 'assets/Profile.jpg',
                image: imageUrl,
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customText(title, TextType.subtitle,
                            color: AppColor.navyBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const Gap(12),
                    ],
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: customText(
                      amount,
                      TextType.paragraphTitleNormal,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: customText(date, TextType.normal, fontSize: 10),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.2,
                    maxHeight: MediaQuery.of(context).size.height * 0.030),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.navyBlue,
                ),
                child: const Center(
                  child: FittedBox(
                    child: Text(
                      "Successful",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
