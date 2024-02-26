import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/auth/data/datasources/auth_datasource.dart';
import 'package:injectable/injectable.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImpl({
    required AuthDatasource authDatasource,
  }) : _authDatasource = authDatasource;

  @override
  Future<EitherOf<AppFailure, UserEntity>> loginWithCnpjAndNameAndPassword({
    required UserEntity user,
  }) async {
    try {
      final UserEntity userLogged =
          await _authDatasource.loginWithCnpjAndNameAndPassword(user: user);

      return resolve(userLogged);
    } on AppFailure catch (error) {
      return reject(AuthFailure(message: error.message));
    } catch (error) {
      return reject(AuthFailure(message: 'auth.error.loginFailed'));
    }
  }

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> logout() async {
    try {
      await _authDatasource.logout();

      return resolve(const VoidSuccess());
    } on AppFailure catch (error) {
      return reject(AuthFailure(message: error.message));
    } catch (error) {
      return reject(AuthFailure(message: 'auth.error.logoutFailed'));
    }
  }

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> verifyLicense(
      {required String license}) async {
    try {
      await _authDatasource.verifyLicense(license: license);

      return resolve(const VoidSuccess());
    } on AppFailure catch (error) {
      return reject(AuthFailure(message: error.message));
    } catch (error) {
      return reject(AuthFailure(message: 'Erro ao tentar verificar licença!'));
    }
  }

  @override
  Future<EitherOf<AppFailure, UserEntity?>> autoLogin() async {
    try {
      final UserEntity? user = await _authDatasource.autoLogin();
      return resolve(user);
    } on AppFailure catch (error) {
      return reject(AuthFailure(message: error.message));
    } catch (error) {
      return reject(AuthFailure(message: 'Erro ao tentar fazer login'));
    }
  }
}
