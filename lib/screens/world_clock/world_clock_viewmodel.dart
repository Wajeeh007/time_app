import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/common_functions.dart';
import 'package:time_app/screens/world_clock/stored_timezone_details.dart';
import 'package:timezone/timezone.dart' as zt ;

class WorldClockViewModel extends GetxController {

  RxList<StoredTimezoneDetails> timezones = <StoredTimezoneDetails>[].obs;
  RxString currentHour = ''.obs;
  RxString currentMin = ''.obs;
  RxString currentSec = ''.obs;
  RxString currentMeridian = ''.obs;
  RxString currentDate = ''.obs;
  RxString chosenGroupValue = 'Asia/Karachi'.obs;

  @override
  void onInit() async {
    await checkLocalStorage();
    super.onInit();
  }

  checkLocalStorage() async {
    final list = await GetStorage().read('timezone');
    if(list != null) {
      list.forEach((element) => timezones.add(StoredTimezoneDetails.fromJson(element)));
      getTimeOfAll();
    } else {
      getSystemLocalTimezone();
    }
  }

  getTimeOfAll() {
    for (var element in timezones) {
      element.currentDateTime = zt.TZDateTime.now(zt.getLocation(element.databaseName!));
    }
    initializeTime();
  }

  getSystemLocalTimezone() async {
    final value = await FlutterTimezone.getLocalTimezone();
    final name = CommonFunctions.splitName(value);
    timezones.add(
      StoredTimezoneDetails(
          isSelected: true,
          timezoneName: name,
          databaseName: value),
    );
    chosenGroupValue.value = name;
    getTimeOfAll();
    List jsonList = [];
    for (var element in timezones) {
      jsonList.add(element.toJson());
    }
    await GetStorage().write('timezone', jsonList);
  }

  initializeTime() {
    final now = DateTime.now();
    currentHour.value = DateFormat('hh').format(now);
    currentMin.value = DateFormat('mm').format(now);
    currentSec.value = DateFormat('ss').format(now);
    currentMeridian.value = DateFormat('a').format(now);
    incrementTime();
  }

  incrementTime() {
    Future.delayed(const Duration(seconds: 1), () {
      final now = DateTime.now();
      currentHour.value = DateFormat('hh').format(now);
      currentMin.value = DateFormat('mm').format(now);
      currentSec.value = DateFormat('ss').format(now);
      currentMeridian.value = DateFormat('a').format(now);
      for (var element in timezones) {
        element.currentDateTime = zt.TZDateTime.now(zt.getLocation(element.databaseName!));
        timezones.refresh();
      }
      incrementTime();
    });
  }
}