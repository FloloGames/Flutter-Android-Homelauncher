enum AppModelType {
  normal,
  hidden,
  favorite,
}

class AppModel {
  final int? id;
  final int sortedIndex;
  final String packageName;
  final String displayName;
  final AppModelType type;

  const AppModel({
    this.id,
    required this.sortedIndex,
    required this.displayName,
    required this.type,
    required this.packageName,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        id: json["id"],
        sortedIndex: json["sortedIndex"],
        packageName: json["packageName"],
        displayName: json["displayName"],
        type: _appModelFromString(json["type"]),
      );
  static AppModelType _appModelFromString(String appModelStr) {
    switch (appModelStr.toLowerCase()) {
      case 'normal':
        return AppModelType.normal;
      case 'hidden':
        return AppModelType.hidden;
      case 'favorite':
        return AppModelType.favorite;
      default:
        throw ArgumentError('Invalid AppModelType string: $appModelStr');
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sortedIndex": sortedIndex,
        "packageName": packageName,
        "displayName": displayName,
        "type": type.name,
      };
}
