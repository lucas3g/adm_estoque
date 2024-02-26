import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';
import 'params/shared_params.dart';

@Injectable(as: LocalStorage)
class SharedPreferencesService implements LocalStorage {
  final SharedPreferences preferences;

  SharedPreferencesService({required this.preferences});

  @override
  Future<T?> getData<T>(String key) async {
    final Object? result = preferences.get(key);

    if (result == null) {
      return null;
    }

    switch (T) {
      case const (Map<String, dynamic>):
        return jsonDecode(result as String);
      case const (List<String>):
        return result as T;
      default:
        return result as T;
    }
  }

  @override
  Future<bool> setData<T>({required SharedParams<T> params}) async {
    switch (T) {
      case String:
        return await preferences.setString(params.key, params.value as String);
      case int:
        return await preferences.setInt(params.key, params.value as int);
      case bool:
        return await preferences.setBool(params.key, params.value as bool);
      case double:
        return await preferences.setDouble(params.key, params.value as double);
      case const (Map<String, dynamic>):
        return await preferences.setString(
            params.key, jsonEncode(params.value as Map<String, dynamic>));
      case const (List<String>):
        return await preferences.setStringList(
            params.key, params.value as List<String>);
    }
    return false;
  }

  @override
  Future<bool> removeData(String key) async {
    return await preferences.remove(key);
  }
}

class SharedPreferencesException implements Exception {
  final String message;

  SharedPreferencesException(this.message);
}
