import 'package:adm_estoque/app/core/data/clients/local_storage/local_storage.dart';
import 'package:adm_estoque/app/core/data/clients/local_storage/params/shared_params.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/storage_keys.dart';
import 'package:adm_estoque/app/modules/user/domain/adapters/user_adapter.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import 'user_local_datasource.dart';

@Injectable(as: UserLocalDataSource)
class SharedPrefsUserLocalDatasourceImpl implements UserLocalDataSource {
  final LocalStorage _localStorage;

  SharedPrefsUserLocalDatasourceImpl({
    required LocalStorage localStorage,
  }) : _localStorage = localStorage;

  @override
  Future<void> cacheUser(UserEntity user) async {
    try {
      final SharedParams<Map<String, dynamic>> params =
          SharedParams<Map<String, dynamic>>(
        key: StorageKeys.user,
        value: UserAdapter.fromEntity(user).toJson(),
      );

      await _localStorage.setData<Map<String, dynamic>>(params: params);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getUser() async {
    try {
      final Map<String, dynamic>? user =
          await _localStorage.getData<Map<String, dynamic>>(StorageKeys.user);
      if (user != null) {
        return UserAdapter.fromJson(user).toEntity();
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      if (await _localStorage.removeData(StorageKeys.user)) {
        AppGlobal.instance.user = null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
