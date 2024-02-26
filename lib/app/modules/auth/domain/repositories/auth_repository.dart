import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';

import '../../../user/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<EitherOf<AppFailure, UserEntity>> loginWithCnpjAndNameAndPassword({
    required UserEntity user,
  });

  Future<EitherOf<AppFailure, VoidSuccess>> verifyLicense(
      {required String license});

  Future<EitherOf<AppFailure, VoidSuccess>> logout();

  Future<EitherOf<AppFailure, UserEntity?>> autoLogin();
}
