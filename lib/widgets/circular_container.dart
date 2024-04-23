import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helpers/constants.dart';
import '../helpers/theme_helpers.dart';
import 'hour_min_sec_meridian.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    required this.title,
    required this.hour,
    required this.min,
    required this.sec,
    required this.children
  });

  final String title;
  final RxString hour;
  final RxString min;
  final RxString sec;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: primaryDarkGrey,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: primaryPurple.withOpacity(0.1),
                spreadRadius: 20,
                blurRadius: 60
            )
          ]
      ),
      width: Get.width * 0.85,
      height: Get.height * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: ThemeHelper.textTheme.bodyMedium,),
          const SizedBox(height: 20,),
          HourMinSecMeridian(currentHour: hour, currentMin: min, currentSec: sec),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children)
        ],
      ),
    );
  }
}
