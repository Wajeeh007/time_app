import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddAlarmViewModel extends GetxController {

  FixedExtentScrollController hourScrollController = FixedExtentScrollController();
  FixedExtentScrollController minScrollController = FixedExtentScrollController();
  FixedExtentScrollController meridianScrollController = FixedExtentScrollController();
  List<String> hours = ['01','02','03','04','05','06','07','08','09','10','11','12'];
  List<String> mins = ['01','02','03','04','05','06','07','08','09','10','11','12'];
  List<String> meridian = ['AM', 'PM'];
  
  @override
  void onInit() {
    for(int i = 0; i <= 59; i++) {
      if(i < 10) {
        mins.add('0$i');
      } else {
        mins.add('$i');
      }
    }
    super.onInit();
  }
  
}