// lib/core/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class LocalStorageService {
  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
  Future<void> setBool(String key, bool value);
  Future<void> setDouble(String key, double value);
  Future<void> setStringList(String key, List<String> value);
  Future<void> setObject(String key, Map<String, dynamic> value);

  String? getString(String key);
  int? getInt(String key);
  bool? getBool(String key);
  double? getDouble(String key);
  List<String>? getStringList(String key);
  Map<String, dynamic>? getObject(String key);

  Future<bool> remove(String key);
  Future<bool> clear();
  bool containsKey(String key);
  Set<String> getKeys();
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageServiceImpl(this._prefs);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    await _prefs.setString(key, jsonString);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  @override
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  @override
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
