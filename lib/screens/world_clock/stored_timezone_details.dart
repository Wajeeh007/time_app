class StoredTimezoneDetails {

  String? databaseName;
  String? timezoneName;
  bool? isSelected;
  DateTime? currentDateTime;

  StoredTimezoneDetails({
    this.timezoneName,
    this.isSelected,
    this.databaseName,
    this.currentDateTime,
  });

  StoredTimezoneDetails.fromJson(Map<String, dynamic> json) {
    timezoneName = json['timezone_name'];
    isSelected = json['is_selected'];
    databaseName = json['database_name'];
    currentDateTime = json['current_datetime'].runtimeType == String ? DateTime.parse(json['current_datetime']) : json['current_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timezone_name'] = timezoneName;
    data['is_selected'] = isSelected;
    data['database_name'] = databaseName;
    return data;
  }
}