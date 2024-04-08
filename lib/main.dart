import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:time_app/helpers/routes.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {

  tz.initializeTimeZones();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeHelper.darkTheme,
      title: 'Time App',
      getPages: Routes.pages,
      initialRoute: Routes.initRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeHelper.lightTheme,
      // home: AddTimeZoneView(),
    );
  }
}