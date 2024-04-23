import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_app/screens/alarms/alarms_view.dart';
import 'package:time_app/screens/tab_bar/tab_bar_viewmodel.dart';
import 'package:time_app/screens/world_clock/world_clock_view.dart';

import '../../helpers/constants.dart';

class MainTabBarView extends StatelessWidget {
  MainTabBarView({super.key});

  final TabBarViewModel viewModel = Get.put(TabBarViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlack,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? primaryBlack : Colors.white,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBar(
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: viewModel.tabController,
              indicatorColor: primaryPurple,
              labelColor: primaryPurple,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
              enableFeedback: false,
              tabs: const [
                Tab(icon: Icon(Icons.watch_later_rounded, size: 28),),
                Tab(icon: Icon(Icons.alarm, size: 28,),),
                Tab(icon: Icon(Icons.timer_outlined, size: 28,)),
                Tab(icon: Icon(Icons.hourglass_empty_outlined, size: 28,)),
              ],
            ),
        ),
      ),
      body: TabBarView(
        controller: viewModel.tabController,
          children: [
            WorldClockView(),
            AlarmsView(),
            WorldClockView(),
            WorldClockView()
          ]
      ),
    );
  }
}
