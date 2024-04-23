import 'package:flutter/material.dart';

class AlarmModel {

  TimeOfDay? time;
  bool? isOn;
  List<int>? days;
  String? day;
  String? hour;
  String? min;
  String? meridian;
  DateTime? nextDate;

  AlarmModel({this.days, this.isOn, this.time, this.day, this.min, this.hour, this.meridian, this.nextDate});

  AlarmModel.fromJson(Map<String, dynamic> json) {
    time = TimeOfDay(hour: json['hour'], minute: json['min']);
    isOn = json['is_on'];
    if(json['days'] != null) {
      days = [];
      json['days'].forEach((v) => days?.add(v));
    }
  }
  
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['hour'] = time?.hour;
    data['min'] = time?.minute;
    data['is_on'] = isOn;
    if(days != null) {
      data['days'] = days;
    }
    return data;
  }
}