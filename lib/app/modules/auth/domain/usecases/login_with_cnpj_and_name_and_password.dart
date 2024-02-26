import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginWithCnpjAndNameAndPasswordUsecase
    implements UseCase<UserEntity, UserEntity> {
  final AuthRepository _authRepository;

  LoginWithCnpjAndNameAndPasswordUsecase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, UserEntity>> call(UserEntity user) {
    return _authRepository.loginWithCnpjAndNameAndPassword(user: user);
  }
}
