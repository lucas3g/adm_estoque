import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/config/domain/repositories/config_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeIpServerClientHttpUseCase implements UseCase<VoidSuccess, String> {
  final ConfigRepository _configRepository;

  ChangeIpServerClientHttpUseCase({required ConfigRepository configRepository})
      : _configRepository = configRepository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(String args) async {
    return await _configRepository.changeIpServerClientHttp(args);
  }
}
