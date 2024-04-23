import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:time_app/screens/world_clock/world_clock_viewmodel.dart';
import 'package:time_app/widgets/add_button.dart';
import 'package:time_app/widgets/headline_container.dart';
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
              const HeadlineContainer(title: 'TIMEZONE'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Obx(() => Column(
                    children: List.generate(
                        viewModel.timezones.length,
                            (index) => timezoneWidget(
                                name: viewModel.timezones[index].timezoneName!,
                                time: viewModel.timezones[index].currentDateTime!,
                              index: index,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AddButton(onTap: () => Get.toNamed(Routes.addTimezone),)
      ],
    );
  }

  Widget timezoneWidget({required String name, required DateTime time, required int index}) {

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
                groupValue: viewModel.chosenGroupValue,
                onChanged: (value) => viewModel.changeMainTime(index),
                fillColor: MaterialStateProperty.resolveWith((states) => primaryPurple),
              )
            ],
          )
        ],
      ),
    );
  }
}