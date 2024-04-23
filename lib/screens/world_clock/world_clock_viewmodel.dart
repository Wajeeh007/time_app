import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/common_functions.dart';
import 'package:time_app/screens/world_clock/stored_timezone_details.dart';
import 'package:timezone/timezone.dart' as zt ;

class WorldClockViewModel extends GetxController {

  /// List for all saved zones
  RxList<StoredTimezoneDetails> timezones = <StoredTimezoneDetails>[].obs;

  /// Variables to show time on top of World Clock
  RxString currentHour = ''.obs;
  RxString currentMin = ''.obs;
  RxString currentSec = ''.obs;
  RxString currentMeridian = ''.obs;
  RxString currentDate = ''.obs;

  /// Variables for radio button
  String chosenGroupValue = '';
  DateTime chosenDateTime = DateTime.now();
  int chosenIndex = 0;

  @override
  void onInit() async {
    await checkLocalStorage();
    super.onInit();
  }

  /// Check local storage if any saved zones exist
  checkLocalStorage() async {
    final list = await GetStorage().read('timezone');
    if(list != null) {
      list.forEach((element) => timezones.add(StoredTimezoneDetails.fromJson(element)));
      getTimeOfAll();
    } else {
      getSystemLocalTimezone();
    }
  }

  /// Get time of all saved zones
  getTimeOfAll() {
    for (int i = 0; i <= timezones.length - 1; i++) {
      if(timezones[i].isSelected!) {
        chosenGroupValue = timezones[i].timezoneName!;
        chosenDateTime = zt.TZDateTime.now(zt.getLocation(timezones[i].databaseName!));
        chosenIndex = i;
      }
      timezones[i].currentDateTime = zt.TZDateTime.now(zt.getLocation(timezones[i].databaseName!));
    }
    initializeTime();
  }

  /// Get system local time for the first time
  getSystemLocalTimezone() async {
    final value = await FlutterTimezone.getLocalTimezone();
    final name = CommonFunctions.splitName(value);
    timezones.add(
      StoredTimezoneDetails(
          isSelected: true,
          timezoneName: name,
          databaseName: value),
    );
    chosenGroupValue = name;
    chosenDateTime = DateTime.now();
    getTimeOfAll();
    await CommonFunctions().saveList(timezones, 'timezone');
  }

  /// Set the time to display
  initializeTime() {
    currentHour.value = DateFormat('hh').format(chosenDateTime);
    currentMin.value = DateFormat('mm').format(chosenDateTime);
    currentSec.value = DateFormat('ss').format(chosenDateTime);
    currentMeridian.value = DateFormat('a').format(chosenDateTime);
    incrementTime();
  }

  /// Increment time to keep it updated
  incrementTime() {
    Future.delayed(const Duration(seconds: 1), () {
      chosenDateTime = chosenDateTime.add(const Duration(seconds: 1));
      currentHour.value = DateFormat('hh').format(chosenDateTime);
      currentMin.value = DateFormat('mm').format(chosenDateTime);
      currentSec.value = DateFormat('ss').format(chosenDateTime);
      currentMeridian.value = DateFormat('a').format(chosenDateTime);
      for (var element in timezones) {
        element.currentDateTime = zt.TZDateTime.now(zt.getLocation(element.databaseName!));
        timezones.refresh();
      }
      incrementTime();
    });
  }

  /// Change the time on World clock
  changeMainTime(int index) async {
    for (var element in timezones) {
      element.isSelected = false;
    }
    timezones[index].isSelected = true;
    getTimeOfAll();
    chosenDateTime = timezones[index].currentDateTime!;
    chosenIndex = index;
    chosenGroupValue = timezones[index].timezoneName!;
    await CommonFunctions().saveList(timezones, 'timezone');
  }
}