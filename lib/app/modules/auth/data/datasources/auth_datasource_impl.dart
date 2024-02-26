import 'package:adm_estoque/app/core/data/clients/http/client_http.dart';
import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/http_failure.dart';
import 'package:adm_estoque/app/core/domain/entities/network_failure.dart';
import 'package:adm_estoque/app/core/domain/entities/response_entity.dart';
import 'package:adm_estoque/app/modules/user/domain/adapters/user_adapter.dart';
import 'package:injectable/injectable.dart';

import '../../../user/data/datasources/local/user_local_datasource.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/auth_failure.dart';
import 'auth_datasource.dart';

@Injectable(as: AuthDatasource)
class AuthDatasourceImpl implements AuthDatasource {
  final ClientHttp _clientHttp;
  final UserLocalDataSource _userLocalDataSource;

  AuthDatasourceImpl({
    required ClientHttp clientHttp,
    required UserLocalDataSource storageDatasource,
  })  : _clientHttp = clientHttp,
        _userLocalDataSource = storageDatasource;

  @override
  Future<UserEntity> loginWithCnpjAndNameAndPassword(
      {required UserEntity user}) async {
    try {
      return await _loginBackend(user: user);
    } catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _userLocalDataSource.logoutUser();
    } catch (error) {
      throw _handleError(error);
    }
  }

  Future<UserEntity> _loginBackend({required UserEntity user}) async {
    try {
      _clientHttp.setBaseUrl(AppGlobal.instance.baseUrl);

      _clientHttp.setHeaders(UserAdapter.toJsonLogin(user: user));

      final HttpResponseEntity<Map<String, dynamic>?> response =
          await _clientHttp.get(AppEndpoints.login.path);

      final Map<String, dynamic>? json = response.data;

      final int statusCode = response.statusCode;

      if (statusCode >= 500) {
        throw AuthFailure(message: 'Conexão com o servidor perdida!');
      }

      if (statusCode == 401) {
        throw AuthFailure(message: 'Usuário ou senha incorretos!');
      }

      if (statusCode != 200) {
        throw AuthFailure(message: 'Erro ao tentar fazer login!');
      }

      if (json == null) {
        throw AuthFailure(message: 'Usuário ou senha incorretos!');
      }

      json['CNPJ'] = user.cnpj.value;

      final UserEntity userLogged = UserAdapter.fromJson(json).toEntity();

      await _persistUser(userLogged);

      return userLogged;
    } on NetworkFailure catch (error) {
      throw AuthFailure(message: error.message);
    } on HttpFailure catch (error) {
      throw AuthFailure(message: error.message);
    } catch (error) {
      throw _handleError(error);
    }
  }

  Future<void> _persistUser(UserEntity user) async {
    await _userLocalDataSource.cacheUser(user);
    AppGlobal.instance.setUser(user);
  }

  @override
  Future<void> verifyLicense({required String license}) async {
    try {
      _clientHttp
          .setHeaders(<String, dynamic>{'cnpj': 'licenca', 'id': license});

      _clientHttp.setBaseUrl(AppGlobal.instance.baseUrlLincese);

      final HttpResponseEntity<Map<String, dynamic>> response =
          await _clientHttp.get(AppEndpoints.license.path);

      final dynamic data = response.data;

      if (response.statusCode != 200) {
        throw AuthFailure(message: 'Licença inválida!');
      }

      if (data.isEmpty) {
        throw AuthFailure(message: 'Licença não encontrada!');
      }

      if (data['ATIVO'] == 'S') {
        AppGlobal.instance.device?.setActive(true);
      }

      if (data['ATIVO'] == 'N') {
        AppGlobal.instance.device?.setActive(false);
      }

      _clientHttp
          .setHeaders(<String, dynamic>{'Content-Type': 'application/json'});
      _clientHttp.setBaseUrl(AppGlobal.instance.baseUrl);
    } catch (error) {
      throw _handleError(error);
    }
  }

  @override
  Future<UserEntity?> autoLogin() async {
    try {
      final UserEntity? user = await _userLogged();

      if (user == null) {
        return null;
      }

      return user;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserEntity?> _userLogged() async {
    final UserEntity? user = await _userLocalDataSource.getUser();

    return user;
  }

  AuthFailure _handleError(dynamic error) {
    if (error is AuthFailure) {
      return error;
    }

    if (error is HttpFailure) {
      return AuthFailure(message: error.message);
    }

    return AuthFailure(message: 'Erro ao tentar fazer login!');
  }
}
