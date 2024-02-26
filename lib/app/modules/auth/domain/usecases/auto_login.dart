import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class AutoLoginUsecase implements UseCase<UserEntity?, NoArgs> {
  final AuthRepository _authRepository;

  AutoLoginUsecase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, UserEntity?>> call(NoArgs noArgs) {
    return _authRepository.autoLogin();
  }
}
