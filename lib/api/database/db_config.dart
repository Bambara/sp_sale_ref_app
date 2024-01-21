import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseConfig {
  static var instance;

  static FirebaseFirestore getInstance() {
    instance = FirebaseFirestore.instance;
    instance.settings = const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
    return instance;
  }
}
