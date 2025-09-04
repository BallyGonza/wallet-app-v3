import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:template_app/data/data.dart';

class HiveService {
  // This function initializes Hive and opens the necessary boxes.
  static Future<void> initializeHive() async {
    try {
      // Registering the UserModelAdapter to serialize/deserialize UserModel objects.
      Hive.registerAdapter(UserModelAdapter());
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      // Opening a box to store UserModel objects.
      await Hive.openBox<UserModel>('users_box');
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Failed to initialize Hive: $e');
      }
    }
  }
}
