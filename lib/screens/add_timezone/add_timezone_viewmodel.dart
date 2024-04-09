import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_app/helpers/constants.dart';
import 'package:time_app/screens/add_timezone/timezones_model.dart';
import 'package:time_app/screens/world_clock/stored_timezone_details.dart';
import 'package:time_app/screens/world_clock/world_clock_viewmodel.dart';
import 'package:timezone/timezone.dart' as zt;

class AddTimeZoneViewModel extends GetxController {

  RxList<TimezonesModel> timezones = <TimezonesModel>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {

    final locations = zt.timeZoneDatabase.locations;
    final WorldClockViewModel viewModel = Get.find();
    locations.forEach((key, value) async {
      final nameSplitted = value.name.split('/');
      String name = '';
      if(nameSplitted.length > 1) {
        for (var element in nameSplitted) {
          String subName = '';
          final elementSplitted = element.split('_');
          if(elementSplitted.length > 1) {
            for (var element2 in elementSplitted) {
              if(element2 == elementSplitted.first){
                subName = element2;
              } else {
                subName = '$subName $element2';
              }

              if(element2 == elementSplitted.last) {
                if (element == nameSplitted.first) {
                  name = subName;
                } else {
                  name = '$name, $subName';
                }
              }
            }
          } else {
            if(element == nameSplitted.first) {
              name = element;
            } else {
              name = '$name, $element';
            }
          }
        }
      } else {
        final elementSplitted = nameSplitted.first.split('_');
        if(elementSplitted.length > 1) {
          for(var element2 in elementSplitted) {
            if(element2 == elementSplitted.first) {
              name = element2;
            } else {
              name = '$name $element2';
            }
          }
        } else {
          name = elementSplitted.first;
        }
      }
      final dateTime = zt.TZDateTime.now(zt.getLocation(value.name));
      timezones.add(TimezonesModel(locationName: name, currentDateTime: dateTime, databaseName: value.name));
      int index = viewModel.timezones.indexWhere((element) => element.timezoneName == name);
      if(index != -1) {
        timezones.last.alreadySelected = true;
      } else {
        timezones.last.alreadySelected = false;
      }
    });
    super.onInit();
  }

  splitName(String locationName) {

  }

  addTimezone(int index) {
    if (timezones[index].alreadySelected != true) {
      final WorldClockViewModel viewModel = Get.find();
      viewModel.timezones.add(
          StoredTimezoneDetails(
            timezoneName: timezones[index].locationName,
            databaseName: timezones[index].databaseName,
            currentDateTime: timezones[index].currentDateTime,
          )
      );
      viewModel.timezones.refresh();
      timezones[index].alreadySelected = true;
      timezones.refresh();
      Get.back();
      Constants.showToast('Timezone added');
    } else {
      Constants.showToast('Timezone already added');
    }
  }
}