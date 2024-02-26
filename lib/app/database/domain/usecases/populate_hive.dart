import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/database/domain/repositories/database_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PopulateHiveUseCase implements UseCase<VoidSuccess, NoArgs> {
  final DatabaseRepository _repository;

  PopulateHiveUseCase({required DatabaseRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(NoArgs args) async {
    return await _repository.populateHive();
  }
}
