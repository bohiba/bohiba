import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'global_service.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  /// Current DB version
  static int dbversion = 26;

  /*================  DB CONFIG  =================== */

  factory DatabaseService() {
    return _instance;
  }

  Future<void> initDB() async {
    _database ??= await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    String filePath = '';
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // databaseFactory = databaseFactory;
      filePath = await getDatabasesPath();
    }

    String dbPath = '$filePath/bohiba.db';
    GlobalService.printHandler('DB Path: $dbPath');
    return openDatabase(
      dbPath,
      version: dbversion,
      onCreate: (db, version) async => await _onCreateDB(dbCreate: db),
      onDowngrade: (db, oldVersion, newVersion) async => await _recreateDB(dbReCreate: db),
      onUpgrade: (db, oldVersion, newVersion) async => await _recreateDB(dbReCreate: db),
    );
  }

  Future<void> _onCreateDB({required Database dbCreate}) async {
    await dbCreate.execute(strTableProfile);
    await dbCreate.execute(strLoggedInUser);
    await dbCreate.execute(strFavourite);
    await dbCreate.execute(strTruck);
    await dbCreate.execute(strDriver);
    await dbCreate.execute(strTrip);
    await dbCreate.execute(strReassignment);
    await dbCreate.execute(strExpense);
    await dbCreate.execute(strPayment);
    await dbCreate.execute(strDocument);
    await dbCreate.execute(strOwnerExpense);
    await dbCreate.execute(strOpenDriver);
    await dbCreate.execute(strMines);
    await dbCreate.execute(strNews);
    await dbCreate.execute(strRating);
  }

  Future<void> _recreateDB({required Database dbReCreate}) async {
    try {
      await dbReCreate.transaction((trxcn) async {
        await trxcn.execute('DROP TABLE IF EXISTS $tblProfile');
        await trxcn.execute('DROP TABLE IF EXISTS $tblLoggedInUserList');
        await trxcn.execute('DROP TABLE IF EXISTS $tblUserFav');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTrucks');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTrips');
        await trxcn.execute('DROP TABLE IF EXISTS $tblDriver');
        await trxcn.execute('DROP TABLE IF EXISTS $tblReassignment');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTripExpense');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTripPayment');
        await trxcn.execute('DROP TABLE IF EXISTS $tblDocument');
        await trxcn.execute('DROP TABLE IF EXISTS $tblOwnerExpense');
        await trxcn.execute('DROP TABLE IF EXISTS $tblOpenDriver');
        await trxcn.execute('DROP TABLE IF EXISTS $tblMines');
        await trxcn.execute('DROP TABLE IF EXISTS $tblNews');
        await trxcn.execute('DROP TABLE IF EXISTS $tblRating');

        await trxcn.execute(strTableProfile);
        await trxcn.execute(strLoggedInUser);
        await trxcn.execute(strFavourite);
        await trxcn.execute(strTruck);
        await trxcn.execute(strDriver);
        await trxcn.execute(strTrip);
        await trxcn.execute(strReassignment);
        await trxcn.execute(strExpense);
        await trxcn.execute(strPayment);
        await trxcn.execute(strDocument);
        await trxcn.execute(strOwnerExpense);
        await trxcn.execute(strOpenDriver);
        await trxcn.execute(strMines);
        await trxcn.execute(strNews);
        await trxcn.execute(strRating);
      });
    } catch (e) {
      GlobalService.printHandler('DB RECREATE ERROR: $e');
    }
  }

  Future<void> closeDB() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> clearDBData() async {
    try {
      await closeDB();
      await initDB();
      await _database!.transaction((Transaction trxcn) async {
        await trxcn.execute('DROP TABLE IF EXISTS $tblProfile');
        await trxcn.execute('DROP TABLE IF EXISTS $tblLoggedInUserList');
        await trxcn.execute('DROP TABLE IF EXISTS $tblUserFav');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTrucks');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTrips');
        await trxcn.execute('DROP TABLE IF EXISTS $tblDriver');
        await trxcn.execute('DROP TABLE IF EXISTS $tblReassignment');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTripExpense');
        await trxcn.execute('DROP TABLE IF EXISTS $tblTripPayment');
        await trxcn.execute('DROP TABLE IF EXISTS $tblDocument');
        await trxcn.execute('DROP TABLE IF EXISTS $tblOwnerExpense');
        await trxcn.execute('DROP TABLE IF EXISTS $tblOpenDriver');
        await trxcn.execute('DROP TABLE IF EXISTS $tblMines');
        await trxcn.execute('DROP TABLE IF EXISTS $tblNews');
        await trxcn.execute('DROP TABLE IF EXISTS $tblRating');

        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblProfile' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblLoggedInUserList' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblUserFav' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblTrucks' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblTrips' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblDriver' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblReassignment' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblTripExpense' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblTripPayment' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblDocument' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblOwnerExpense' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblOpenDriver' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblMines' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblNews' ''');
        await trxcn.execute('''DELETE FROM sqlite_sequence WHERE name = '$tblRating' ''');
        await trxcn.execute(strTableProfile);
        await trxcn.execute(strLoggedInUser);
        await trxcn.execute(strFavourite);
        await trxcn.execute(strTruck);
        await trxcn.execute(strDriver);
        await trxcn.execute(strTrip);
        await trxcn.execute(strReassignment);
        await trxcn.execute(strExpense);
        await trxcn.execute(strPayment);
        await trxcn.execute(strDocument);
        await trxcn.execute(strOwnerExpense);
        await trxcn.execute(strOpenDriver);
        await trxcn.execute(strMines);
        await trxcn.execute(strNews);
        await trxcn.execute(strRating);
      });
    } catch (e) {
      GlobalService.printHandler('CLEAR DB ERROR ${e.toString()}');
    }
  }

  Future<void> clearTbl(String tblName) async {
    if (_database != null && _database!.isOpen) {
      await _database!.execute('delete from $tblName');
      await _database!.execute('''delete from sqlite_sequence where name='$tblName';''');
    }
  }

  /*================  CRUD  =================== */
  Future<int> insertData(String query) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }
      return await _database!.rawInsert(query);
    } catch (e) {
      GlobalService.printHandler('DB PUT ERROR: $e');
      return 0;
    }
  }

  Future<int> upsertData({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }
      return await _database!.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      GlobalService.printHandler('DB PUT ERROR: $e');
      return 0;
    }
  }

  Future<int> insertAllData(String tableName, List<Map<String, dynamic>> dataList) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }

      final batch = _database!.batch();
      for (final data in dataList) {
        batch.insert(
          tableName,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      final bulkInsert = await batch.commit(
        exclusive: true,
        noResult: false,
        continueOnError: false,
      );
      return bulkInsert.length;
    } catch (e) {
      GlobalService.printHandler('DB UPDATING BULK DATA ERROR: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>?> executeQuery(String query) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }
      return await _database!.rawQuery(query);
    } catch (e) {
      GlobalService.printHandler('DB RETRIVE ERROR: $e');
      return null;
    }
  }

  Future<int> updateData(String query, {List<Object>? argument}) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }
      return await _database!.rawUpdate(query, argument);
    } catch (e) {
      GlobalService.printHandler('DB UPDATE ERROR: $e');
      return 0;
    }
  }

  Future<int> delete(String query) async {
    try {
      if (_database == null || !(_database!.isOpen)) {
        await initDB();
      }
      return await _database!.rawDelete(query);
    } catch (e) {
      GlobalService.printHandler('DB DELETE ERROR: $e');
      return 0;
    }
  }

  /*================  CREATE TABLE COMMAND  =================== */
  String strTableProfile = '''
  CREATE TABLE IF NOT EXISTS $tblProfile (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , uuid TEXT
  , image TEXT
  , name TEXT
  , email TEXT
  , mobileNumber TEXT
  , roleId INTEGER NOT NULL DEFAULT 9
  , dob TEXT
  , jobStatus INTEGER NOT NULL DEFAULT 0
  , trucks INTEGER NOT NULL DEFAULT 0
  , driver INTEGER NOT NULL DEFAULT 0
  , panNumber TEXT
  , aadharNumber TEXT
  , dlNumber TEXT
  , verified INTEGER NOT NULL DEFAULT 0
  , houseNo TEXT
  , locality TEXT
  , street TEXT
  , city TEXT
  , district TEXT
  , state TEXT
  , country TEXT
  , pinCode TEXT
  )''';

  String strLoggedInUser = '''
  CREATE TABLE IF NOT EXISTS $tblLoggedInUserList (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , userUuid TEXT
  , name TEXT
  , email TEXT
  , roleId INTEGET NOT NULL DEFAULT 9
  , token TEXT
  )''';

  String strFavourite = '''
  CREATE TABLE IF NOT EXISTS $tblUserFav (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , userTruckId INTEGER
  , truckId INTEGER
  , userDriverId INTEGER
  , driverId INTEGER
  , minesId INTEGER
  , isFav INTEGER NOT NULL DEFAULT 0
  , name TEXT
  , image TEXT
  , nameCode TEXT
  , type TEXT NOT NULL DEFAULT 'unknown'
  )''';

  String strTruck = '''
  CREATE TABLE IF NOT EXISTS $tblTrucks (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , isFav INTEGER NOT NULL DEFAULT 0
  , image TEXT
  , vhNumber TEXT
  , driverId INTEGER
  , driverImage TEXT
  , driverUuid TEXT
  , driverName TEXT
  , driverMobileNumber TEXT
  , ownerId INTEGER
  , ownerImage TEXT
  , ownerUuid TEXT
  , ownerName TEXT
  , ownerMobileNumber TEXT
  , registrationPlace TEXT
  , registrationDate TEXT
  , rcStatus INTEGER
  , rcModel TEXT
  , rcOwnerSr INTEGER
  , vhDesc TEXT
  , vhBrand TEXT
  , vhModel TEXT
  , vhEngineNo TEXT
  , vhChassisNo TEXT
  , vhFuelType TEXT
  , vhUnladenWeight INTEGER
  , vhFinancer TEXT
  , vhInsuranceNo TEXT
  , vhInsuranceCompany TEXT
  , insuranceUpto TEXT
  , taxUpto TEXT
  , puccUpto TEXT
  , fitnessUpto TEXT
  , updatedAt TEXT
  , createdAt TEXT
  )''';

  String strDriver = '''
  CREATE TABLE IF NOT EXISTS $tblDriver (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , isFav INTEGER NOT NULL DEFAULT O
  , isSynced INTEGER
  , image TEXT
  , uuid TEXT
  , name TEXT
  , email TEXT
  , mobileNumber TEXT
  , dob TEXT
  , roleId INTEGER NOT NULL DEFAULT 8
  , isActive INTEGER
  , connect TEXT
  , verified TEXT NOT NULL DEFAULT 'unverified'
  , houseNo TEXT
  , locality TEXT
  , street TEXT
  , city TEXT
  , district TEXT
  , state TEXT
  , country TEXT
  , pinCode TEXT
  , licenseNumber TEXT
  , dlStatus TEXT
  , cov TEXT
  , rto TEXT
  , validFrom TEXT
  , validTill TEXT
  , updatedAt TEXT
  )''';

  String strTrip = '''
  CREATE TABLE IF NOT EXISTS $tblTrips (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , isFav INTEGER NOT NULL DEFAULT 0
  , tripCode TEXT
  , tripStatus INTEGER
  , originId INTEGER
  , originName TEXT
  , originNameCode TEXT
  , originType INTEGER
  , originLat DOUBLE
  , originLng DOUBLE
  , originStatus INTEGER
  , destinationId INTEGER
  , destinationName TEXT
  , destinationNameCode TEXT
  , destinationType INTEGER
  , destinationLat DOUBLE
  , destinationLng DOUBLE
  , destinationStatus INTEGER
  , startedAt DATE
  , endedAt DATE
  , transporterId INTEGER
  , materialType TEXT
  , loadWeight DOUBLE NOT NULL DEFAULT 0.0
  , shortWeight DOUBLE NOT NULL DEFAULT 0.0
  , rate DOUBLE NOT NULL DEFAULT 0.0
  , fnId INTEGER
  , fnAmount DOUBLE NOT NULL DEFAULT 0.0
  , fnPayment DOUBLE NOT NULL DEFAULT 0.0
  , fnExpense DOUBLE NOT NULL DEFAULT 0.0
  , fnProfit DOUBLE NOT NULL DEFAULT 0.0
  , vhId INTEGER
  , vhNumber TEXT
  , vhModel TEXT
  , vhDesc TEXT
  , dvId INTEGER
  , dvUuid TEXT
  , dvName TEXT
  , dvMobile TEXT
  , ownerId INTEGER
  , ownerUuid TEXT
  , ownerName TEXT
  , ownerMobileNumber TEXT
  , updatedAt TEXT 
  , UNIQUE(id)
  )''';

  String strReassignment = '''
  CREATE TABLE IF NOT EXISTS $tblReassignment (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , tripId INTEGER NOT NULL DEFAULT 0
  , vhNumber TEXT
  , reassignmentAt TEXT
  , reAssignVhNumber TEXT
  , reason TEXT
  , UNIQUE(id)
  , FOREIGN KEY (tripId) REFERENCES $tblTrips(id) ON DELETE CASCADE
  )''';

  String strExpense = '''
  CREATE TABLE IF NOT EXISTS $tblTripExpense (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , tripId INTEGER NOT NULL DEFAULT 0 
  , expenseType TEXT
  , paymentMode TEXT
  , paid DOUBLE NOT NULL DEFAULT 0.0
  , paidTo TEXT
  , expenseDate TEXT
  , remarks TEXT
  , UNIQUE(id)
  , FOREIGN KEY (tripId) REFERENCES $tblTrips(id) ON DELETE CASCADE
  )''';

  String strPayment = '''
    CREATE TABLE IF NOT EXISTS $tblTripPayment (
      id INTEGER PRIMARY KEY AUTOINCREMENT
    , tripId INTEGER NOT NULL DEFAULT 0
    , payerType TEXT
    , payementMode TEXT
    , amount DOUBLE NOT NULL DEFAULT 0.0
    , paidBy TEXT
    , receivedBy TEXT
    , paymentTime TEXT
    , UNIQUE(id)
    , FOREIGN KEY (tripId) REFERENCES $tblTrips(id) ON DELETE CASCADE
  )''';

  String strDocument = '''
  CREATE TABLE IF NOT EXISTS $tblDocument (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , tripId INTEGER NOT NULL DEFAULT 0
  , docType TEXT
  , image TEXT
  , uploadedBy TEXT
  , uploadedAt TEXT
  , UNIQUE(id)
  , FOREIGN KEY (tripId) REFERENCES $tblTrips(id) ON DELETE CASCADE
  )''';

  String strOwnerExpense = '''
  CREATE TABLE IF NOT EXISTS $tblOwnerExpense (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , ownerUuid TEXT
  , vhNumber TEXT
  , expenseType TEXT
  , amount DOUBLE NOT NULL DEFAULT 0.0
  , date TEXT
  , description TEXT
  , severity TEXT
  , updatedAt TEXT
  , createdAt TEXT
  )''';

  String strOpenDriver = '''
  CREATE TABLE IF NOT EXISTS $tblOpenDriver (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , isSynced INT
  , image TEXT
  , uuid TEXT
  , name TEXT
  , email TEXT
  , mobileNumber TEXT
  , dob TEXT
  , roleId INTEGER NOT NULL DEFAULT 8
  , isActive TEXT
  , connect TEXT
  , panNumber TEXT
  , aadharNumber TEXT
  , dlNumber TEXT
  , verified TEXT NOT NULL DEFAULT 'unverified'
  , houseNo TEXT
  , locality TEXT
  , street TEXT
  , city TEXT
  , district TEXT
  , state TEXT
  , country TEXT
  , pinCode TEXT
  , licenseNumber TEXT
  , dlStatus TEXT
  , cov TEXT
  , rto TEXT
  , validFrom TEXT
  , validTill TEXT
  , updatedAt TEXT
  )''';

  String strRating = '''
  CREATE TABLE IF NOT EXISTS $tblRating (
    id INTEGER PRIMARY KEY AUTOINCREMENT
    , driverUuid INTEGER
    , reviewerId INTEGER
    , reviewerUuid TEXT
    , reviewerImage TEXT
    , reviewerName TEXT
    , role INTEGER
    , rating DOUBLE NOT NULL DEFAULT 0.0
    , feedback TEXT
    , createdAt TEXT
    , UNIQUE(id)
  )''';

  String strMines = '''
  CREATE TABLE IF NOT EXISTS $tblMines (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , isFav INTEGER NOT NULL DEFAULT 0
  , logo TEXT
  , name TEXT
  , nameCode TEXT
  , state TEXT
  , district TEXT
  , latitude DOUBLE
  , longitude DOUBLE
  , status TEXT
  , avgWaitingTime INTEGER
  , UNIQUE(id)
  )''';

  String strNews = '''
  CREATE TABLE IF NOT EXISTS $tblNews (
    id INTEGER PRIMARY KEY AUTOINCREMENT
  , title TEXT
  , description TEXT
  , image TEXT
  , redirectUrl TEXT
  , authorName TEXT
  , updatedAt TEXT
  , UNIQUE(id)
  )''';
}

final String tblProfile = 'tblprofile';
final String tblNews = 'tblnews';
final String tblMines = 'tblmines';
final String tblTrips = 'tbltrips';
final String tblTrucks = 'tbltruck';
final String tblDriver = 'tbldriver';
final String tblRating = 'tblrating';
final String tblUserFav = 'tblUserFav';
final String tblOpenDriver = 'tblOpenDriver';
final String tblLoggedInUserList = 'tblUserList';
final String tblOwnerExpense = 'tblOwnerExpense';
final String tblReassignment = 'tblReassignment';
final String tblTripExpense = 'tblTripExpense';
final String tblTripPayment = 'tblTripPayment';
final String tblDocument = 'tblDocument';

String sqlValue(dynamic value) {
  if (value == null) return 'NULL';

  if (value is num) return value.toString();

  if (value is bool) return value ? '1' : '0';

  if (value is DateTime) return "'${value.toIso8601String()}'";

  return "'${value.toString().replaceAll("'", "''")}'";
}
