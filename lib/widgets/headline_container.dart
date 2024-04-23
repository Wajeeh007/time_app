import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/constants.dart';
import '../helpers/theme_helpers.dart';

class HeadlineContainer extends StatelessWidget {
  const HeadlineContainer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? primaryGrey : containerWhite,
      ),
      child: Text(
        title,
        style: ThemeHelper.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4
        ),
      ),
    );
  }
}