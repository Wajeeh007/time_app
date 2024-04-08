import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_app/widgets/unit_and_desc.dart';

import '../helpers/theme_helpers.dart';

class HourMinSecMeridian extends StatelessWidget {
  const HourMinSecMeridian({
    super.key,
    required this.currentHour,
    required this.currentMin,
    required this.currentSec,
    this.currentMeridian,
  });

  final RxString currentHour;
  final RxString currentMin;
  final RxString currentSec;
  final RxString? currentMeridian;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnitAndDesc(value: currentHour.value, desc: 'hour'),
        Text(':', style: ThemeHelper.textTheme.labelMedium?.copyWith(height: 3),),
        UnitAndDesc(value: currentMin.value, desc: 'min'),
        Text(':', style: ThemeHelper.textTheme.labelMedium?.copyWith(height: 3)),
        UnitAndDesc(value: currentSec.value, desc: 'sec'),
        currentMeridian != null ? UnitAndDesc(value: currentMeridian!.value, fontSize: 12, height: 3.8) : const SizedBox(),
      ],
    ),
    );
  }
}
