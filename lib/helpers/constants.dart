import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

const primaryPurple = Color(0xffaa6cfc);
const primaryGrey = Color(0xff4a4d55);
const primaryDarkGrey = Color(0xff16151b);
const primaryBlack = Color(0xff070609);
const containerWhite = Color(0xfff6f8fa);
const lightGrey = Color(0xff9e9e9e);

const weekdays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

class Constants {

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Get.isDarkMode ? primaryGrey : containerWhite,
        textColor: Get.isDarkMode ? Colors.white : primaryDarkGrey,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

}