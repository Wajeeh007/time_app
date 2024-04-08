import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:time_app/screens/world_clock/world_clock_viewmodel.dart';
import 'package:time_app/widgets/hour_min_sec_meridian.dart';
import 'package:time_app/widgets/unit_and_desc.dart';
import '../../helpers/constants.dart';
import '../../helpers/routes.dart';

class WorldClockView extends StatelessWidget {
  WorldClockView({super.key});

  final WorldClockViewModel viewModel = Get.put(WorldClockViewModel());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: HourMinSecMeridian(
                  currentHour: viewModel.currentHour,
                  currentMin: viewModel.currentMin,
                  currentSec: viewModel.currentSec,
                  currentMeridian: viewModel.currentMeridian,
                )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                child: Image.asset('assets/images/world_map.png', height: 200, fit: BoxFit.fill,),
              ),
              const SizedBox(height: 30,),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? primaryGrey : containerWhite,
                ),
                child: Text(
                  'TIMEZONE',
                  style: ThemeHelper.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    letterSpacing: 1.4
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Obx(() => Column(
                    children: List.generate(
                        viewModel.timezones.length,
                            (index) => timezoneWidget(name: viewModel.timezones[index].timezoneName!, time: viewModel.timezones[index].currentDateTime!)),
                  ),
                ),
              ),
            ],
          ),
        ),
        timezoneAddBtn()
      ],
    );
  }

  Widget timezoneWidget({required String name, required DateTime time}) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              UnitAndDesc(value: DateFormat('hh').format(time)),
              Text(':', style: ThemeHelper.textTheme.labelMedium?.copyWith(height: 3),),
              UnitAndDesc(value: DateFormat('mm').format(time)),
              Text(
                DateFormat('a').format(time),
                style: ThemeHelper.textTheme.labelMedium,
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: Get.width * 0.4,
                  child: Text(
                    name,
                    textAlign: TextAlign.end,
                    style: ThemeHelper.textTheme.bodyMedium,
                    overflow: TextOverflow.clip,
                  maxLines: 1,),
              ),
              Radio(
                value: name,
                groupValue: viewModel.chosenGroupValue.value,
                onChanged: (value) => viewModel.chosenGroupValue.value = value!,
                fillColor: MaterialStateProperty.resolveWith((states) => primaryPurple),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget timezoneAddBtn() {
    return Positioned(
      bottom: 15,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.addTimezone),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryPurple,
              boxShadow: [
                BoxShadow(
                  color: primaryGrey,
                  spreadRadius: 1,
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ]
          ),
          child: const Icon(
            Icons.add,
            size: 23,
          ),
        ),
      ),
    );
  }
}