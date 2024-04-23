import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/common_functions.dart';
import 'package:time_app/helpers/constants.dart';
import 'package:time_app/screens/alarms/alarm_model.dart';

class AlarmsViewModel extends GetxController{

  /// List for Alarms
  RxList<AlarmModel> alarms = <AlarmModel>[].obs;

  /// Date, Hour, Min and Sec variables for UI
  RxString hour = '00'.obs;
  RxString min = "00".obs;
  RxString sec = '00'.obs;
  RxString dateAndTimeText = ''.obs;

  /// General Variables
  DateTime dateTime = DateTime.now();
  int? chosenAlarmIndex;
  bool exit = false;
  bool noOtherAlarm = true;
  RxBool editAlarmList = false.obs;

  @override
  void onInit() {
    checkLocalStorage();
    super.onInit();
  }

  /// Check local storage if alarms are stored
  checkLocalStorage() async {
    if(GetStorage().hasData('alarms')) {
      final data = await GetStorage().read('alarms');
      data.forEach((element) => alarms.add(AlarmModel.fromJson(element)));
      alarms.refresh();
      getNextAlarm();
    } else {
      createDummyAlarms();
    }
  }

  /// Create Dummy Alarms in case no alarms exist in local storage
  createDummyAlarms() async {
    for(int i = 0; i <= 2; i++) {
      alarms.add(AlarmModel(isOn: false, time: TimeOfDay(hour: i+7, minute: 0)));
      if(i==0) {
        alarms.last.days = [1,2,3,4,5,6,7];
      } else if(i == 1) {
        alarms.last.days = [1,2,3,4,5];
      } else{
        alarms.last.days = [1,3,5];
      }
      alarms.refresh();
    }
    await CommonFunctions().saveList(alarms, 'alarms');
    incrementTime();
  }

  /// Check and Get the next alarm time from the list
  getNextAlarm() {
    double alarmDoubleValue = 0.0;
    for (int i = 0; i <= alarms.length - 1; i++) {
        if(alarms[i].isOn!) {
          if(alarms[i].days!.contains(DateTime.now().weekday)){
            alarmDoubleValue = alarms[i].time!.hour + (alarms[i].time!.minute / 60);
            chosenAlarmIndex = i;
          } else {
            dateTime = DateTime.now();
            for(int j = 1; j <= 6; j++) {
              if(alarms[i].days!.contains(dateTime.add(Duration(days: j)).weekday)){
                num tempHour = dateTime.difference(DateTime.now().add(Duration(days: j))).inHours;
                num tempMin = dateTime.difference(DateTime.now()).inMinutes.remainder(60);

                final calculatedValue = tempHour + (tempMin / 60);
                if(alarmDoubleValue == 0.0) {
                  chosenAlarmIndex = i;
                  alarmDoubleValue = calculatedValue.toDouble();
                  noOtherAlarm = false;
                } else if(calculatedValue < alarmDoubleValue) {
                  chosenAlarmIndex = i;
                  noOtherAlarm = false;
                  alarmDoubleValue = calculatedValue.toDouble();
                }
                break;
              }
            }
          }
        }

        if(i == alarms.length - 1){
          if(alarmDoubleValue != 0.0) {
            calculateAlarmDate(alarms[chosenAlarmIndex!]);
          } else {
            hour.value = '00';
            min.value = '00';
            sec.value = '00';
            dateAndTimeText.value = '';
            chosenAlarmIndex = null;
            noOtherAlarm = true;
            exit = true;
          }
        }
        incrementTime();
    }
  }

  /// Check Alarm time if it is greater or shorter than the alarm that is currently on
  checkAlarmTime(AlarmModel alarm, int index) {
    if(chosenAlarmIndex == null){
      exit = false;
      calculateAlarmDate(alarm);
      noOtherAlarm = false;
      chosenAlarmIndex = index;
    } else {
      dateTime = DateTime.now();
      final chosenAlarmDouble = alarms[chosenAlarmIndex!].time!.hour + (alarms[chosenAlarmIndex!].time!.minute/60);
      final newAlarmDouble = alarm.time!.hour + (alarm.time!.minute/60);
      final currentTimeDouble = TimeOfDay.now().hour + (TimeOfDay.now().minute/60);
      if(newAlarmDouble > currentTimeDouble) {
        if(alarm.days!.contains(DateTime.now().weekday)) {
          if(newAlarmDouble < chosenAlarmDouble) {
            exit = true;
            chosenAlarmIndex = index;
            dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            calculateHourAndMin();
          } else {
            final hour = alarm.time!.hour - TimeOfDay.now().hour;
            final min = alarm.time!.minute - TimeOfDay.now().minute;
            toastFunction(hourValue: hour, minValue: min);
          }
        } else {
          for(int i = 1; i <= 6; i++) {
            final date = dateTime.add(Duration(days: i));
            if(alarm.days!.contains(date.weekday)) {
              dateTime = DateTime(date.year, date.month, date.day, alarm.time!.hour, alarm.time!.minute);
              calculateHourAndMin();
              break;
            }
          }
        }
      } else {
        for (int i = 1; i <= 6; i++) {
            DateTime date = dateTime.add(Duration(days: i));
            if (alarm.days!.contains(date.weekday)) {
              date = DateTime(date.year, date.month, date.day, alarm.time!.hour, alarm.time!.minute);
              num tempHour = date.difference(DateTime.now()).inHours;
              num tempMin = date.difference(DateTime.now()).inMinutes.remainder(60);
              if(tempHour + (tempMin / 60) < (int.parse(hour.value) + (int.parse(min.value) / 60))) {
                dateTime = date;
                hour.value = tempHour.toString();
                min.value = twoDigits(tempMin);
                dateAndTimeText.value = '${DateFormat.MMMEd().format(dateTime)}, ${DateFormat.jm().format(dateTime)}';
                chosenAlarmIndex = index;
                toastFunction();
              } else {
                toastFunction(hourValue: tempHour, minValue: tempMin);
              }
              break;
            }
          }
      }
    }
  }

  String twoDigits(num n) {
    return n.toString().padLeft(2, "0");
  }

  /// Calculate and set alarm date
  calculateAlarmDate(AlarmModel alarm) {
    final now = TimeOfDay.now();
    final alarmDoubleValue = alarm.time!.hour + (alarm.time!.minute/60);
    final nowDoubleValue = now.hour + (now.minute/60);

    if(alarmDoubleValue > nowDoubleValue) {
      if (alarm.days!.contains(DateTime.now().weekday)) {
        dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, alarm.time!.hour, alarm.time!.minute);
        calculateHourAndMin();
      } else {
        dateTime = DateTime.now();
        for(int i = 1; i <= 6; i++) {
          final date = dateTime.add(Duration(days: i));
          if(alarm.days!.contains(date.weekday)) {
            dateTime = DateTime(date.year, date.month, date.day, alarm.time!.hour, alarm.time!.minute);
            calculateHourAndMin();
            break;
          }
        }
      }
    } else {
      dateTime = DateTime.now();
      for(int i = 1; i <= 6; i++) {
        final date = dateTime.add(Duration(days: i));
        if(alarm.days!.contains(date.weekday)) {
          dateTime = DateTime(date.year, date.month, date.day, alarm.time!.hour, alarm.time!.minute);
          calculateHourAndMin();
          break;
        }
      }
    }
  }

  /// Calculate and set the hours and minutes for alarm
  calculateHourAndMin() {

    sec.value = (60 - DateTime.now().second).toString();
    final alarmHourAndMin = TimeOfDay.fromDateTime(dateTime);
    final now = TimeOfDay.now();

    num tempHour;

    if (dateTime.day != DateTime.now().day) {

      tempHour = dateTime.difference(DateTime.now()).inHours;
    } else {
      tempHour = alarmHourAndMin.hour - now.hour;
    }

    hour.value = tempHour.toString();
    final tempMin = dateTime.difference(DateTime.now()).inMinutes.remainder(60);
    min.value = twoDigits(tempMin);
    dateAndTimeText.value = '${DateFormat.MMMEd().format(dateTime)}, ${DateFormat.jm().format(dateTime)}';
    // toastFunction();
    if(noOtherAlarm) {
      decrementTime();
    }
  }

  /// Decrement Time for Alarm
  decrementTime() {
    if(exit) {
      exit = false;
      return;
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (hour.value == '00' && min.value == '00' && sec.value == '00') {
          //TODO: Implement Notification for Alarm
          getNextAlarm();
        } else {
          if (sec.value == '00' && (min.value != '00' || hour.value != '00')) {
            if (min.value == '00' && hour.value != '00') {
              if (int.parse(hour.value) <= 10) {
                hour.value = '0${(int.parse(hour.value) - 1)}';
              } else {
                hour.value = (int.parse(hour.value) - 1).toString();
              }
              min.value = '59';
              sec.value = '59';
            } else if (min.value != '00') {
              if (int.parse(min.value) <= 10) {
                min.value = '0${(int.parse(min.value) - 1)}';
              } else {
                min.value = (int.parse(min.value) - 1).toString();
              }
              sec.value = '59';
            }
          } else if (int.parse(sec.value) <= 10) {
            sec.value = "0${(int.parse(sec.value) - 1)}";
          } else {
            sec.value = (int.parse(sec.value) - 1).toString();
          }
        }
        decrementTime();
      });
    }
  }

  /// Toggle Alarm status and proceed with relevant condition
  changeAlarmStatus(int index) async {
    alarms[index].isOn = !alarms[index].isOn!;
    alarms.refresh();

    await CommonFunctions().saveList(alarms, 'alarms');

    if(alarms[index].isOn!) {
      checkAlarmTime(alarms[index], index);
    } else {
      if(chosenAlarmIndex == index) {
        getNextAlarm();
      } else {
      }
    }
  }

  /// Show Toast for setting alarm
  toastFunction({num? hourValue, num? minValue}) {
    if(hourValue == null && minValue == null) {
      if(hour.value == '00') {
        Constants.showToast('Alarm set for ${min.value} minutes');
      } else {
        if(min.value == '00') {
          Constants.showToast('Alarm set for ${hour.value} hours');
        } else {
          Constants.showToast('Alarm set for ${hour.value} hours and ${min.value} minutes');
        }
      }
    } else {
      if(hourValue == 0) {
        Constants.showToast('Alarm set for $minValue minutes');
      } else {
        if(minValue == 0) {
          Constants.showToast('Alarm set for $hourValue hours');
        } else {
          Constants.showToast('Alarm set for $hourValue hours and $minValue minutes');
        }
      }
    }
  }

  /// Increment Time to update Date and Day in the UI
  incrementTime() {
    final currentDateTime = DateTime.now();
    Future.delayed(const Duration(seconds: 1), () {
      currentDateTime.add(const Duration(seconds: 1));
      for (var element in alarms) {
        final dateToTime = TimeOfDay.fromDateTime(currentDateTime);
        if((element.time!.hour + (element.time!.minute / 60)) < (dateToTime.hour + (dateToTime.minute / 60))) {
          for(int i = 1; i <= 6; i++) {
            final date = currentDateTime.add(Duration(days: i));
            if(element.days!.contains(date.weekday)) {
              element.day = weekdays[date.weekday - 1];
              element.nextDate = date;
              alarms.refresh();
              break;
            }
          }
        }
      }
      incrementTime();
    });
  }

  /// Delete Alarm from Alarms List
  deleteAlarm(int index) {
    alarms.removeAt(index);
    alarms.refresh();
    if(chosenAlarmIndex == index) {
      getNextAlarm();
    }
    CommonFunctions().saveList(alarms, 'alarms');
  }
}