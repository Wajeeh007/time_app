import 'package:get/get.dart';
import 'package:time_app/screens/add_alarm/add_alarm_view.dart';
import 'package:time_app/screens/add_timezone/add_timezone_view.dart';
import 'package:time_app/screens/tab_bar/tab_bar_view.dart';
import 'package:time_app/screens/world_clock/world_clock_view.dart';

class Routes {
  
  static const initRoute = "/";
  static const worldClock = "/worldClock";
  static const addTimezone = "/addTimezone";
  static const addAlarm = '/addAlarm';

  static final pages = [
    GetPage(name: initRoute, page: () => MainTabBarView()),
    GetPage(name: worldClock, page: () => WorldClockView()),
    GetPage(name: addTimezone, page: () => AddTimeZoneView()),
    GetPage(name: addAlarm, page: () => AddAlarmView()),
  ];
  
}