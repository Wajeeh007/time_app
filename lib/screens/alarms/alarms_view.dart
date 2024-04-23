import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/constants.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:time_app/screens/alarms/alarms_viewmodel.dart';
import 'package:time_app/widgets/add_button.dart';
import 'package:time_app/widgets/circular_container.dart';
import 'package:time_app/widgets/headline_container.dart';

import '../../helpers/routes.dart';

class AlarmsView extends StatelessWidget {
  AlarmsView({super.key});

  final AlarmsViewModel viewModel = Get.put(AlarmsViewModel());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 15.0, top: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularContainer(
                  title: 'NEXT ALARM',
                  hour: viewModel.hour,
                  min: viewModel.min,
                  sec: viewModel.sec,
                  children: viewModel.dateAndTimeText.value != '' ? [
                    const Icon(CupertinoIcons.bell_fill, color: primaryPurple, size: 12,),
                    const SizedBox(width: 8,),
                    Text('Fri, 31 Mar, 07:00', style: ThemeHelper.textTheme.labelSmall?.copyWith(color: primaryPurple),)
                  ] : [const SizedBox()],
              ),
              const HeadlineContainer(title: 'ALARMS'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Obx(() => viewModel.alarms.isEmpty ? Center(
                  child: Text('No Alarms', style: ThemeHelper.textTheme.bodyMedium,),
                ) : Column(
                  children: List.generate(
                    viewModel.alarms.length,
                        (index) => alarmWidget(index),
                  ),
                ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => AddButton(
            onTap: () => viewModel.editAlarmList.isTrue ? viewModel.editAlarmList.value = false : Get.toNamed(Routes.addAlarm),
            icon: viewModel.editAlarmList.isTrue ? Icons.done : null
        ),)
      ],
    );
  }

  Widget alarmWidget(int index) {

    viewModel.alarms[index].nextDate = DateTime.now();

    if(viewModel.alarms[index].time!.hour < 12) {
      viewModel.alarms[index].meridian = 'AM';
    } else {
      viewModel.alarms[index].meridian = 'PM';
    }

    final alarmDoubleValue = viewModel.alarms[index].time!.hour + (viewModel.alarms[index].time!.minute/60);
    final currentDoubleValue = TimeOfDay.now().hour + (TimeOfDay.now().minute/60);

    if(alarmDoubleValue > currentDoubleValue) {
      if(viewModel.alarms[index].days!.contains(DateTime.now().weekday)) {
        viewModel.alarms[index].day = DateFormat.E().format(DateTime.now());
      } else {
        for(int i = 0; i <= 5; i++) {
          final date = viewModel.alarms[index].nextDate!.add(Duration(days: i));
          if(viewModel.alarms[index].days!.contains(date.weekday)) {
            viewModel.alarms[index].day = DateFormat.E().format(date);
            break;
          }
        }
      }
    } else {
      for(int i = 1; i <= 6; i++) {
        final date = viewModel.alarms[index].nextDate!.add(Duration(days: i));
        if(viewModel.alarms[index].days!.contains(date.weekday)) {
          viewModel.alarms[index].nextDate = date;
          viewModel.alarms[index].day = DateFormat.E().format(date);
          break;
        } else {
          continue;
        }
      }
    }

    if(viewModel.alarms[index].time!.hour < 12) {
      viewModel.alarms[index].hour = viewModel.twoDigits(viewModel.alarms[index].time!.hour);
    } else {
      final convertedHour = viewModel.alarms[index].time!.hour - 12;
      viewModel.alarms[index].hour = viewModel.twoDigits(convertedHour);
    }

    viewModel.alarms[index].min = viewModel.twoDigits(viewModel.alarms[index].time!.minute);

    viewModel.alarms.refresh();

    return GestureDetector(
      onLongPress: () {
        viewModel.editAlarmList.value = true;
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: viewModel.editAlarmList.value ? [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 0),
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: primaryDarkGrey,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        viewModel.alarms[index].hour!,
                        style: ThemeHelper.textTheme.bodyLarge,
                      ),
                      Text(' : ', style: ThemeHelper.textTheme.labelMedium,),
                      Text(viewModel.alarms[index].min!, style: ThemeHelper.textTheme.bodyLarge,),
                      const SizedBox(width: 7,),
                      Text(viewModel.alarms[index].meridian!, style: ThemeHelper.textTheme.labelSmall)
                    ],
                  ),
                  daysText(index),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () => viewModel.deleteAlarm(index),
              icon: const Icon(Icons.delete, color: primaryGrey,),
          )
        ] : [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            viewModel.alarms[index].hour!,
                            style: ThemeHelper.textTheme.bodyLarge,
                          ),
                          Text(' : ', style: ThemeHelper.textTheme.labelMedium,),
                          Text(viewModel.alarms[index].min!, style: ThemeHelper.textTheme.bodyLarge,),
                          const SizedBox(width: 7,),
                          Text(viewModel.alarms[index].meridian!, style: ThemeHelper.textTheme.labelSmall)
                        ],
                      ),
                      Row(
                        children: [
                          Text("${viewModel.alarms[index].day}, ", style: ThemeHelper.textTheme.labelMedium,),
                          Text(DateFormat.MMMMd().format(viewModel.alarms[index].nextDate!), style: ThemeHelper.textTheme.labelMedium,),
                          const SizedBox(width: 5,),
                          switchBtn(index),
                        ],
                      )
                    ],
                  ),
                  daysText(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget switchBtn(int index) {
    return GestureDetector(
      onTap: () {
        viewModel.changeAlarmStatus(index);
      },
      child: Stack(
        children: [
          Container(
            width: 45,
            height: 21.5,
            decoration: BoxDecoration(
              color: viewModel.alarms[index].isOn! ? primaryPurple : const Color(0xff1E2430),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: 1.5,
            left: viewModel.alarms[index].isOn! ? 26 : 2,
            child: Container(
              padding: EdgeInsets.zero,
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget daysText(int index) {
    return listEquals(viewModel.alarms[index].days, [1,2,3,4,5,6,7]) ?
    Text(
      'Everyday',
      style: ThemeHelper.textTheme.labelSmall,
    ) : listEquals(viewModel.alarms[index].days, [1,2,3,4,5]) ? Text(
      'Weekdays',
      style: ThemeHelper.textTheme.labelSmall,
    ) : Row(
      children: List.generate(viewModel.alarms[index].days!.length, (index1) {
        final weekdayIndex = viewModel.alarms[index].days![index1] - 1;
        if (index1 == 0) {
          return Text(weekdays[weekdayIndex].substring(0, 3),
            style: ThemeHelper.textTheme.labelSmall,);
        } else {
          return Text(', ${weekdays[weekdayIndex].substring(0, 3)}',
            style: ThemeHelper.textTheme.labelSmall,);
        }
      }),
    );
  }
}


// class TimerPainter extends CustomPainter {
//   final double progress;
//
//   TimerPainter({required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     const double strokeWidth = 5.0;
//     final double radius = (size.shortestSide - strokeWidth) / 1.95;
//
//     Paint outerCircle = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = Colors.transparent
//       ..style = PaintingStyle.stroke;
//
//     Paint gradientCircle = Paint()
//       ..strokeWidth = strokeWidth
//       ..shader = const LinearGradient(
//         colors: [ primaryPurple, Colors.transparent ],
//       ).createShader(Rect.fromCircle(
//           center: Offset(size.width / 5, size.height / 5), radius: radius)
//       )
//       ..style = PaintingStyle.stroke;
//
//     Paint spotPaint = Paint()
//       ..color = primaryPurple
//       ..strokeWidth = 5.0
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(
//         Offset(size.width / 2, size.height / 2), radius, outerCircle);
//     canvas.drawArc(
//       Rect.fromCircle(
//           center: Offset(size.width / 2, size.height / 2), radius: radius),
//       -pi / 2,
//       pi * 2 * progress,
//       false,
//       gradientCircle,
//     );
//
//     // Draw a circular spot at the end of the border
//     double spotX = size.width / 2 + radius * cos(pi * 2 * progress - pi / 2);
//     double spotY = size.height / 2 + radius * sin(pi * 2 * progress - pi / 2);
//     canvas.drawCircle(Offset(spotX, spotY), strokeWidth / 2, spotPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
