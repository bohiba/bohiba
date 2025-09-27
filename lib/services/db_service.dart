import 'dart:io';

import 'global_service.dart';
import '/model/open_driver_model.dart';
import '/model/rating_model.dart';
import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';
import '/model/news_model.dart';
import '/model/profile_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBService {
  DBService._private();
  static final DBService _instance = DBService._private();
  factory DBService() => _instance;

  Future<void> initDB() async {
    await Hive.initFlutter();
    await register(ProfileModelAdapter());
    await register(VerificationModelAdapter());
    await register(NewsModelAdapter());
    await register(MinesModelAdapter());
    await register(TripModelAdapter());
    await register(LoadDetailAdapter());
    await register(TripFinanceAdapter());
    await register(TripTruckAdapter());
    await register(TripDriverAdapter());
    await register(TripOwnerAdapter());
    await register(TruckOwnerModelAdapter());
    await register(ReassignmentAdapter());
    await register(TripExpenseAdapter());
    await register(TripPaymentAdapter());
    await register(TripDocumentAdapter());
    await register(TruckModelAdapter());
    await register(TruckDriverModelAdapter());
    await register(RegistrationModelAdapter());
    await register(SpecsModelAdapter());
    await register(ValidityModelAdapter());
    await register(UserFavouriteModelAdapter());
    await register(DriverModelAdapter());
    await register(DriverProfileAdapter());
    await register(DriverAddressAdapter());
    await register(LicenseDetailAdapter());
    await register(RatingModelAdapter());
    await register(ReviewerModelAdapter());
    await register(OpenDriverModelAdapter());
  }

  static Future<void> register<T>(TypeAdapter<T> adapter) async {
    try {
      // if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter<T>(adapter);
      // }
    } on HiveError catch (e) {
      GlobalService.printHandler('HiveRegister: $e');
    } catch (e) {
      GlobalService.printHandler('Error occurred while opening box: $e');
    }
  }

  // Open All box
  Future<void> openAllBox() async {}

  // Open typed box for the model
  Future<void> openBox<T>(String boxName) async {
    try {
      bool isOpen = Hive.isBoxOpen(boxName);
      if (!isOpen) {
        await Hive.openBox<T>(boxName);
        GlobalService.printHandler('Hive Open: $boxName is Open.');
      }
    } on HiveError catch (e) {
      GlobalService.printHandler('OpenBox: $e');
    } catch (e) {
      GlobalService.printHandler('Error occurred while opening box: $e');
    }
  }

  Future<int> putAllData<T>(String boxName, Map<String, T> value) async {
    try {
      if (Hive.isBoxOpen(boxName) == false) {
        await Hive.openBox<T>(boxName);
      }
      final box = Hive.box<T>(boxName);
      await box.putAll(value);
      return 1;
    } on HiveError catch (e) {
      GlobalService.printHandler('PutAll: $e');
      return 0;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return 0;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return 0;
    }
  }

  /// Save a model instance
  Future<int> putData<T>(String boxName, String key, T value) async {
    try {
      await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      await box.put(key, value);
      // GlobalService.printHandler("$boxName to Hive: $key is saved");
      return 1;
    } on HiveError catch (e) {
      GlobalService.printHandler('PutData: $e');
      return 0;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return 0;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return 0;
    }
  }

  Future<List<T>> getAllData<T>(String boxName) async {
    try {
      await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      return box.values.toList();
    } on HiveError catch (e) {
      GlobalService.printHandler('GetAllData: $e');
      return [];
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return [];
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return [];
    }
  }

  /// Get a model instance
  Future<T?> getData<T>(String boxName, String key) async {
    try {
      await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      return box.get(key);
    } on HiveError catch (e) {
      GlobalService.printHandler('GetData: $e');
      return null;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return null;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return null;
    }
  }

  Future<List<T>?> filterList<T>(
    String boxName,
    bool Function(T item) condition,
  ) async {
    try {
      await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      return box.values.where((item) => condition(item)).toList();
    } on HiveError catch (e) {
      GlobalService.printHandler('FilterList: $e');
      return null;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return null;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return null;
    }
  }

  Future<T?> findSingleData<T>(
    String boxName,
    bool Function(T item) condition,
  ) async {
    try {
      await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      return box.values.singleWhere(
        (item) => condition(item),
      );
    } on HiveError catch (e) {
      GlobalService.printHandler('Find Single Data > $e');
      return null;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return null;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return null;
    }
  }

  /// Delete a model instance
  Future<int> deleteData<T>(String boxName, String key) async {
    try {
      // await openBox<T>(boxName);
      final box = Hive.box<T>(boxName);
      await box.delete(key);
      return 1;
    } on HiveError catch (e) {
      GlobalService.printHandler('Delete: $e');
      return 0;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return 0;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return 0;
    }
  }

  Future<int> deleteFromList<T>({
    required HiveObject hiveObject,
    List<T>? list,
    required bool Function(T item) condition,
  }) async {
    try {
      if (list == null) return 0;
      list.removeWhere(condition);
      await hiveObject.save();
      return 1;
    } on HiveError catch (e) {
      GlobalService.printHandler('DeleteFromList: $e');
      return 0;
    } on FileSystemException catch (e) {
      GlobalService.printHandler('File system error: $e');
      return 0;
    } catch (e) {
      GlobalService.printHandler('Unknown error: $e');
      return 0;
    }
  }

  /// Clear entire box
  Future<void> clearBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<T>(boxName);
      }
      final box = Hive.box<T>(boxName);
      await box.clear();
    } catch (e) {
      GlobalService.printHandler("⚠️ Error clearing box $boxName: $e");
    }
  }

  Future<void> clearAllBox() async {
    await clearBox<ProfileModel>(tblProfile);
    await clearBox<NewsModel>(tblNews);
    await clearBox<MinesModel>(tblMines);
    await clearBox<TripModel>(tblTrips);
    await clearBox<DriverModel>(tblDriver);
    await clearBox<TruckModel>(tblTrucks);
    await clearBox<UserFavouriteModel>(tblUserFav);
    await clearBox<OpenDriverModel>(tblOpenDriver);
  }

  /// Check if a key exists
  Future<bool> containsKey<T>(String boxName, String key) async {
    final box = Hive.box<T>(boxName);
    return box.containsKey(key);
  }

  /// Get all keys
  Future<List<String>> getAllKeys<T>(String boxName) async {
    await openBox<T>(boxName);
    final box = Hive.box<T>(boxName);
    return box.keys.cast<String>().toList();
  }

  /// Dispose all open Hive boxes
  Future<void> disposeDB() async {
    await Hive.close();
  }

  Future<void> resetAndReInitDB() async {
    try {
      // Step 1: Close all Hive boxes
      await Hive.close();

      // Step 2: Delete all Hive data from disk
      await Hive.deleteFromDisk();
      GlobalService.printHandler("Hive DB fully cleared from disk.");

      // Step 3: Reinitialize Hive
      await Hive.initFlutter();
      await initDB();

      GlobalService.printHandler("Hive DB re-initialized with all adapters.");
    } catch (e) {
      GlobalService.printHandler("Error in resetAndReInitDB: $e");
    }
  }
}

final String tblProfile = 'tblprofile';
final String tblNews = 'tblnews';
final String tblMines = 'tblmines';
final String tblTrips = 'tbltrips';
final String tblTrucks = 'tbltruck';
final String tblDriver = 'tbldriver';
final String tblUserFav = 'tblUserFav';
final String tblOpenDriver = 'tblOpenDriver';

final String profileKey = 'me';
const int profileTypeID = 0;
const int verficationTypeID = 1;
const int newsTypeID = 2;
const int minesTypeID = 3;
const int tripTypeID = 4;
const int tripLoadDetailTypeID = 5;
const int tripFinanceTypeID = 6;
const int tripTruckTypeID = 7;
const int tripDriverTypeID = 8;
const int tripOwnerTypeID = 9;
const int reassignmentTypeID = 10;
const int tripExpenseTypeID = 11;
const int tripPaymentTypeID = 12;
const int tripDocumentTypeID = 13;
const int truckTypeID = 14;
const int truckDriverTypeID = 15;
const int truckOwnerTypeID = 16;
const int registrationTypeID = 17;
const int specsTypeID = 18;
const int validityTypeID = 19;
const int favTypeID = 20;
const int driverTypeID = 21;
const int driverProfileTypeID = 22;
const int driverAddressTypeID = 23;
const int licenseDetailTypeID = 24;
const int ratingTypeID = 25;
const int reviewerTypeID = 26;
const int openDriverTypeID = 27;
