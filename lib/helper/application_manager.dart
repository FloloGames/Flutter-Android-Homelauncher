import 'package:device_apps/device_apps.dart';

import '../models/app_model.dart';
import 'database_manager.dart';

class ApplicationManager {
  static ApplicationManager? _instance;
  static Future<ApplicationManager> get instance async {
    if (_instance == null) {
      List<Application> applications = await loadApplications();
      _instance = ApplicationManager._(applications);
    }
    return _instance!;
  }

  List<AppModel> _favoriteApps = [];
  List<AppModel> get favoriteApps => _favoriteApps;

  List<AppModel> _hiddenApps = [];
  List<AppModel> get hiddenApps => _hiddenApps;

  // ignore: prefer_final_fields
  List<Application> _applications = [];
  List<Application> get applications => _applications;

  //Constructor
  ApplicationManager._(this._applications) {
    DatabaseManager.addDBChangedCBFunction(() => loadSpecialApps);
  }

  static Future<List<Application>> loadApplications() async {
    List<Application> installedApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
      includeAppIcons: true,
    );

    installedApps.sort((app1, app2) => app1.appName.compareTo(app2.appName));

    return installedApps;
  }

  Future reloadApplications() async {
    _applications = await loadApplications();
  }

  Future loadSpecialApps() async {
    List<AppModel> specialApps = await DatabaseManager.getAllAppModels();
    _favoriteApps = [];
    _hiddenApps = [];
    for (AppModel appModel in specialApps) {
      if (appModel.type == AppModelType.favorite) {
        _favoriteApps.add(appModel);
      } else if (appModel.type == AppModelType.hidden) {
        _hiddenApps.add(appModel);
      }
    }
  }

  bool inHiddenApps(Application app) {
    return hiddenApps.any((element) => element.packageName == app.packageName);
  }

  bool inFavoriteApps(Application app) {
    return favoriteApps
        .any((element) => element.packageName == app.packageName);
  }
}
