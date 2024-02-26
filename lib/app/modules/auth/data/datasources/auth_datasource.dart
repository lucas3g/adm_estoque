import '../../../user/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> loginWithCnpjAndNameAndPassword({
    required UserEntity user,
  });

  Future<void> verifyLicense({required String license});

  Future<void> logout();

  Future<UserEntity?> autoLogin();
}
