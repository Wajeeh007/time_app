import 'package:flutter/material.dart';
import '../helpers/theme_helpers.dart';

class UnitAndDesc extends StatelessWidget {
  const UnitAndDesc({
    super.key,
    required this.value,
    this.desc,
    this.height,
    this.fontSize,
  });

  final String value;
  final String? desc;
  final double? fontSize;
  final double? height;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Text(
            value,
            style: ThemeHelper.textTheme.bodyLarge?.copyWith(
                fontSize: fontSize,
                height: height
            ),
          ),
          const SizedBox(height: 3,),
          desc != null && desc != '' ? Text(
            desc!,
            style: ThemeHelper.textTheme.labelMedium,
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
