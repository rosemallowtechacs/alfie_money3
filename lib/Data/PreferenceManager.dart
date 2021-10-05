import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static PreferenceManager sharedInstance = PreferenceManager();

  //<<<<<<<<<<<<<<<<<<<<<<<< All SETTERS <<<<<<<<<<<<<<<<<<<<<<
  Future<bool> putString(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(key, value);
  }

  Future<bool> putStringList(String key, List<String> value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setStringList(key, value);
  }

  Future<bool> putInt(String key, int value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setInt(key, value);
  }

  Future<bool> putBoolean(String key, bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(key, value);
  }

  Future<bool> putDouble(String key, double value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setDouble(key, value);
  }

  Future<bool> putMap(String key, Map<String, dynamic> dataMap) async {
    return await putString(
        key, json.encode(dataMap)); // json.encode() converts map to string....
  }

  // >>>>>>>>>>>>>>>>>>>>>>>>>> All GETTERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<String> getString(String key, {String defaultValue = ""}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String value = _prefs.getString(key);
    return value != null ? value : defaultValue;
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> value = _prefs.getStringList(key);
    return value != null ? value : List<String>();
  }

  Future<double> getDouble(String key, {double defaultValue = 0}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    double value = _prefs.getDouble(key);
    return value != null ? value : defaultValue;
  }

  Future<int> getInt(String key, {int defaultValue = 0}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int value = _prefs.getInt(key);
    return value != null ? value : defaultValue;
  }

  Future<bool> getBoolean(String key, {bool defaultValue = false}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool value = _prefs.getBool(key);
    return value != null ? value : defaultValue;
  }

  Future<Map<String, dynamic>> getMap(String key) async {
    final jsonStr = await getString(key, defaultValue: "");
    if (jsonStr.isEmpty) {
      return Map();
    } else {
      return json
          .decode(jsonStr); // json.decode() converts string to Map.......
    }
  }

  // >>>>>>>>>>>> CLEAR AND REMOVE DATA >>>>>>>>>>>>>>>>>>>
  Future<bool> remove(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.remove(key);
  }

  Future<bool> clear() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.clear();
  }
}
