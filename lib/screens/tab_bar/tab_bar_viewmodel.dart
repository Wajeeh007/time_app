import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarViewModel extends GetxController with GetTickerProviderStateMixin{

  /// Controller(s)
  late TabController tabController = TabController(length: 4, vsync: this);

}