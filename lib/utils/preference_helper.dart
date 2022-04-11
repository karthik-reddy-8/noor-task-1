import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [storage] holds the instance of FlutterSecureStorage class
FlutterSecureStorage storage = FlutterSecureStorage();

/// method to store key value pairs into preference
/// [key] pass the string key constant
/// [value] pass the value to be stored in the preference w.r.t key
Future<void> writeIntoStorage(String key, Object value) async {
  await storage.write(
    key: key,
    value: value.toString(),
  );
}

/// method to read data from preference
/// [key] pass string key const to retrieve specific value of the key
Future<String> readFromStorage(String key) async {
  return await (storage.read(key: key)) ?? '';
}

/// method to check preference has keys or not
Future<bool> hasPreference() async {
  final Map<String, String> allValues = await storage.readAll();
  return allValues.isNotEmpty;
}

/// method to clear data from preference
Future<void> clearStorage() async {
  await storage.deleteAll();
}

/// method to clear data from preference
Future<void> deleteFromStorage(String key) async {
  await storage.delete(key: key);
}
