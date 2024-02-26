import 'package:adm_estoque/app/core/data/clients/local_database/local_database.dart';
import 'package:adm_estoque/app/core/data/clients/local_database/params/database_params.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LocalDatabase)
class HiveService implements LocalDatabase {
  final HiveInterface hive;

  HiveService({required this.hive});

  @override
  Future<dynamic> getData({required DatabaseParams params}) async {
    try {
      if (hive.isBoxOpen(params.table)) {
        await hive.close();
      }

      final Box<dynamic> box = await hive.openBox(params.table);

      final dynamic result =
          params.key != null ? box.get(params.key) : box.values.toList();

      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> removeData({required DatabaseParams params}) async {
    try {
      final Box<dynamic> box = await hive.openBox(params.table);

      await box.delete(params.key);

      await box.close();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setData({required DatabaseParams params}) async {
    try {
      final Box<dynamic> box = await hive.openBox(params.table);

      await box.put(params.key, params.value!);

      await box.close();

      return true;
    } catch (e) {
      return false;
    }
  }
}
