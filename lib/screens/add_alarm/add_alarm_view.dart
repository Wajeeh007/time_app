import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_app/helpers/constants.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:time_app/screens/add_alarm/add_alarm_viewmodel.dart';

class AddAlarmView extends StatelessWidget {
  AddAlarmView({super.key});

  final AddAlarmViewModel viewModel = Get.put(AddAlarmViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.7))),
        title: Text('New Alarm', style: ThemeHelper.textTheme.bodyMedium,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.done, color: Colors.white.withOpacity(0.7),))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: ListWheelScrollView(
                      controller: viewModel.hourScrollController,
                        itemExtent: 70,
                        children: List.generate(viewModel.hours.length, (index) {
                          return Text(
                            viewModel.hours[index],
                            style: ThemeHelper.textTheme.bodySmall,
                          );
                        })
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ListWheelScrollView(

                      // perspective: 0.005,
                      overAndUnderCenterOpacity: 0.5,
                        controller: viewModel.minScrollController,
                        itemExtent: 70,
                        children: List.generate(viewModel.mins.length, (index) {
                          return Text(
                            viewModel.mins[index],
                            style: ThemeHelper.textTheme.bodySmall,
                          );
                        })
                    ),
                  ),
                  SizedBox(width: 100,
                    child: ListWheelScrollView(
                        controller: viewModel.meridianScrollController,
                        itemExtent: 70,
                        children: List.generate(viewModel.meridian.length, (index) {
                          return Text(
                            viewModel.meridian[index],
                            style: ThemeHelper.textTheme.bodySmall,
                          );
                        })
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
