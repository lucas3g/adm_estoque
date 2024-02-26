import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LogoutUsecase implements UseCase<VoidSuccess, NoArgs> {
  final AuthRepository _authRepository;

  LogoutUsecase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(NoArgs args) {
    return _authRepository.logout();
  }
}
