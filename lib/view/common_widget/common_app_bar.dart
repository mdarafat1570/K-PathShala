// common_app_bar.dart
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color titleColor;
  final double titleFontSize;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = AppColor.gradientStart,
    this.titleColor =AppColor.navyBlue,
    this.titleFontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleFontSize,
          color: titleColor,
        ),
      ),
      centerTitle: true,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: AppColor.navyBlue, // Adjust as needed
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
