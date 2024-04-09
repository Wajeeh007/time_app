import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_app/helpers/common_functions.dart';
import 'package:time_app/helpers/constants.dart';
import 'package:time_app/screens/add_timezone/timezones_model.dart';
import 'package:time_app/screens/world_clock/stored_timezone_details.dart';
import 'package:time_app/screens/world_clock/world_clock_viewmodel.dart';
import 'package:timezone/timezone.dart' as zt;

class AddTimeZoneViewModel extends GetxController {

  /// Lists for timezones data.
  List<TimezonesModel> timezones = <TimezonesModel>[]; // To Store Complete Data
  RxList<TimezonesModel> visibleTimezones = <TimezonesModel>[].obs; // To show timezones to user, can change when user searches a timezone

  /// Controller(s)
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    populateList();
    super.onInit();
  }

  /// Populate Timezones data in lists
  populateList() {
    final locations = zt.timeZoneDatabase.locations;
    final WorldClockViewModel viewModel = Get.find();
    locations.forEach((key, value) {
      final name = CommonFunctions.splitName(value.name);
      final dateTime = zt.TZDateTime.now(zt.getLocation(value.name));
      timezones.add(TimezonesModel(locationName: name, currentDateTime: dateTime, databaseName: value.name));
      int index = viewModel.timezones.indexWhere((element) => element.timezoneName == name);
      if(index != -1) {
        timezones.last.alreadySelected = true;
      } else {
        timezones.last.alreadySelected = false;
      }
      visibleTimezones.add(timezones.last);
      visibleTimezones.refresh();
    });
  }

  /// Add Timezone to World Clock View
  addTimezone(int index) {
    if (visibleTimezones[index].alreadySelected != true) {
      final WorldClockViewModel viewModel = Get.find();
      viewModel.timezones.add(
          StoredTimezoneDetails(
            timezoneName: visibleTimezones[index].locationName,
            databaseName: visibleTimezones[index].databaseName,
            currentDateTime: visibleTimezones[index].currentDateTime,
          )
      );
      viewModel.timezones.refresh();
      visibleTimezones[index].alreadySelected = true;
      visibleTimezones.refresh();
      timezones[index].alreadySelected = true;
      Get.back();
      Constants.showToast('Timezone added');
    } else {
      Constants.showToast('Timezone already added');
    }
  }

  /// Search a specific timezone from lists
  searchTimezone(String searchedZone) {
    Future.delayed(const Duration(milliseconds: 650), () {
      if (searchedZone == '') {
        visibleTimezones.addAll(timezones);
        visibleTimezones.refresh();
      } else {
        visibleTimezones.clear();
        for (var element in timezones) {
          if (element.locationName!.toLowerCase().contains(searchedZone)) {
            visibleTimezones.add(element);
            visibleTimezones.refresh();
          }
        }
      }
    });
  }
}