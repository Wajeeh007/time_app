import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/world_clock/stored_timezone_details.dart';

class CommonFunctions {

  static String splitName(String nameToSplit) {
    final valueSplitted = nameToSplit.split("/");
    String name = '';
    if(valueSplitted.length > 1) {
      for (var element in valueSplitted) {
        final elementSplitted = element.split('_');
        String subName = '';
        if(elementSplitted.length > 1) {
          for (var element2 in elementSplitted) {
            if(element2 == elementSplitted.first) {
              subName = element2;
            } else {
              subName = '$subName $element2';
            }

            if(element2 == elementSplitted.last) {
              if (element == valueSplitted.first) {
                name = subName;
              } else {
                name = '$name, $subName';
              }
            }
          }
        } else {
          if(element == valueSplitted.first) {
            name = element;
          } else {
            name = '$name, $element';
          }
        }
      }
    } else {
      final elementSplitted = valueSplitted.first.split('_');
      if (elementSplitted.length > 1) {
        for (var element2 in elementSplitted) {
          if (element2 == elementSplitted.first) {
            name = element2;
          } else {
            name = '$name $element2';
          }
        }
      } else {
        name = elementSplitted.first;
      }
    }

    return name;
  }

  saveList(RxList<StoredTimezoneDetails> list) async  {
    List jsonList = [];
    for (var element in list) {
      jsonList.add(element.toJson());
    }
    if(GetStorage().hasData('timezone')){
      await GetStorage().remove('timezone');
    }
    await GetStorage().write('timezone', jsonList);
  }

}