import 'package:device_apps/device_apps.dart';
import 'package:flos_launcher/helper/application_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

import '../models/app_model.dart';

/*
Man könnte _dbName zu SpecialApps ändern weil nur die apps gespeichert werden 
die verändert wurden oder Favirisiert oder versteckt wurden
*/

//DatabaseCallBackFunction
typedef DBChangedCBFunc = void Function();

class DatabaseManager {
  static const int _version = 3;
  static const String _dbName = "Applications";

  static List<AppModel> _allAppModels = [];
  static Future<List<AppModel>> get allAppModels async {
    if (_allAppModels.isEmpty) {
      _allAppModels = await getAllAppModels();
    }
    if (_allAppModels.isEmpty) {
      var allApps = await ApplicationManager.loadApplications();
      _allAppModels = _createAllAppModels(allApps);
    }
    _updateAllAppModels();
    return _allAppModels;
  }

  static Future _updateAllAppModels() async {
    var allApps = await ApplicationManager.loadApplications();
    allApps.sort();
    for (Application app in allApps) {
      bool alreadyInAppModels = _allAppModels
          .any((appModel) => appModel.packageName == app.packageName);
      if (alreadyInAppModels) {
        continue;
      } else {}
    }
  }

  static List<AppModel> _createAllAppModels(List<Application> allApps) {
    List<AppModel> appModels = [];
    for (Application app in allApps) {
      AppModel appModel = AppModel(
        sortedIndex: -1,
        displayName: app.appName,
        type: AppModelType.normal,
        packageName: app.packageName,
      );
      appModels.add(appModel);
    }
    return appModels;
  }

  static String _dbFileName() => "$_dbName.db";

  static const String _createTableCommand =
      "CREATE TABLE $_dbName(id INTEGER PRIMARY KEY, sortedIndex INTEGER NOT NULL, packageName TEXT NOT NULL, displayName TEXT NOT NULL, type TEXT NOT NULL);";

  //DatabaseCallBackFunction
  static final List<DBChangedCBFunc> _dbChangedCBFunctions = [];

  static void addDBChangedCBFunction(DBChangedCBFunc func) {
    if (_dbChangedCBFunctions.any((element) => element == func)) return;
    _dbChangedCBFunctions.add(func);
  }

  static void removeDBChangedCBFunction(DBChangedCBFunc func) {
    _dbChangedCBFunctions.remove(func);
  }

  static void _callDBChangedCBFunctions() {
    for (DBChangedCBFunc func in _dbChangedCBFunctions) {
      func.call();
    }
  }

  static Future<Database> _getDatabase() async {
    String databasePath = join(await getDatabasesPath(), _dbFileName());
    return openDatabase(
      databasePath,
      onCreate: (db, version) async => await db.execute(_createTableCommand),
      version: _version,
    );
  }

  static Future deleteDatabase_() async {
    String databasePath = join(await getDatabasesPath(), _dbFileName());

    await deleteDatabase(databasePath);

    _callDBChangedCBFunctions();
  }

  static Future<int> addOrUpdateApp(AppModel appModel) async {
    final db = await _getDatabase();

    List<AppModel> allAppModels = await getAllAppModels();

    if (allAppModels
        .any((element) => element.packageName == appModel.packageName)) {
      AppModel? existingAppModel = allAppModels
          .firstWhere((element) => element.packageName == appModel.packageName);

      return updateApp(
        AppModel(
          displayName: appModel.displayName,
          packageName: appModel.packageName,
          sortedIndex: appModel.sortedIndex,
          type: appModel.type,
          id: existingAppModel.id,
        ),
      );
    }

    int id = await db.insert(
      _dbName,
      appModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _callDBChangedCBFunctions();

    return id;
  }

  static Future<int> updateApp(AppModel appModel) async {
    final db = await _getDatabase();
    int numberOfChangesMade = await db.update(
      _dbName,
      appModel.toJson(),
      where: "id = ?",
      whereArgs: [appModel.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _callDBChangedCBFunctions();

    return numberOfChangesMade;
  }

  static Future<int> deleteApp(AppModel appModel) async {
    final db = await _getDatabase();
    int numberOfRowsAffected = await db.delete(
      _dbName,
      where: "id = ?",
      whereArgs: [appModel.id],
    );
    _callDBChangedCBFunctions();

    return numberOfRowsAffected;
  }

  static Future<List<AppModel>> getAllAppModels() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> jsonDataList = await db.query(_dbName);

    if (jsonDataList.isEmpty) {
      return [];
    }

    return List.generate(
      jsonDataList.length,
      (index) => AppModel.fromJson(jsonDataList[index]),
    );
  }

  static Future<AppModel?> getAppModelByPackageName(String packageName) async {
    List<AppModel> allAppModels = await getAllAppModels();
    if (!allAppModels.any((element) => element.packageName == packageName)) {
      return null;
    }
    return allAppModels
        .firstWhere((element) => element.packageName == packageName);
  }
}
