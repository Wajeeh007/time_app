import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_app/helpers/theme_helpers.dart';
import 'package:time_app/screens/add_timezone/add_timezone_viewmodel.dart';
import '../../helpers/constants.dart';

class AddTimeZoneView extends StatelessWidget {
  AddTimeZoneView({super.key});

  final AddTimeZoneViewModel viewModel = Get.put(AddTimeZoneViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: const SizedBox(),
          bottom: PreferredSize(preferredSize: const Size.fromHeight(20), child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_rounded,)),
                searchField(),
              ],
            ),
          )),
        ),
        body: Obx(() => viewModel.visibleTimezones.isEmpty ? Center(
          child: Text(
            'No Timezone Found',
            style: ThemeHelper.textTheme.bodySmall,
          ),
        ) : Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: viewModel.visibleTimezones.length,
              itemBuilder: (context, index) {
                return timezoneWidget(
                  name: viewModel.visibleTimezones[index].locationName!,
                  time: viewModel.visibleTimezones[index].currentDateTime!,
                  alreadySelected: viewModel.visibleTimezones[index].alreadySelected!,
                  index: index,
                );
              }
          ),
        ),
        )
    );
  }

  Widget searchField() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[ a-zA-Z.,-]'))],
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Get.isDarkMode ? Colors.white : primaryDarkGrey,
        style: const TextStyle(
            fontSize: 15
        ),
        maxLines: 1,
        controller: viewModel.searchController,
        decoration: InputDecoration(
          hintText: 'Search Timezone',
          hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: Get.isDarkMode ? Colors.white.withOpacity(0.8) : primaryDarkGrey.withOpacity(0.8)
          ),
          filled: true,
          fillColor: primaryGrey,
          constraints: const BoxConstraints(maxHeight: 40),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Get.isDarkMode ? primaryGrey : containerWhite)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Get.isDarkMode ? primaryGrey : containerWhite)
          ),
        ),
        onChanged: (value) => viewModel.searchTimezone(value),
      ),
    );
  }

  Widget timezoneWidget({
    required String name,
    required DateTime time,
    required bool alreadySelected,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: GestureDetector(
        onTap: () => viewModel.addTimezone(index),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: ThemeHelper.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(time),
                        style: ThemeHelper.textTheme.labelMedium?.copyWith(
                            color: lightGrey
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(time),
                        style: ThemeHelper.textTheme.labelMedium?.copyWith(
                            color: lightGrey
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 0.6, color: primaryGrey,)
          ],
        ),
      ),
    );
  }
}