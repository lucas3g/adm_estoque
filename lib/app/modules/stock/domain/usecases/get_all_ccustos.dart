import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/domain/repositories/ccusto_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllCustosUseCase implements UseCase<List<CCustoEntity>, NoArgs> {
  final CCustoRepository _ccustoRepository;

  GetAllCustosUseCase({
    required CCustoRepository ccustoRepository,
  }) : _ccustoRepository = ccustoRepository;

  @override
  Future<EitherOf<AppFailure, List<CCustoEntity>>> call(NoArgs args) async {
    return await _ccustoRepository.getAllCCustos();
  }
}
