import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/ccusto_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto_failure.dart';
import 'package:adm_estoque/app/modules/stock/domain/repositories/ccusto_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CCustoRepository)
class CCustoRepositoryImpl implements CCustoRepository {
  final CCustoDataSource _ccustoDataSource;

  CCustoRepositoryImpl({
    required CCustoDataSource ccustoDataSource,
  }) : _ccustoDataSource = ccustoDataSource;
  @override
  Future<EitherOf<AppFailure, List<CCustoEntity>>> getAllCCustos() async {
    try {
      final List<CCustoEntity> result = await _ccustoDataSource.getAllCCustos();

      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(CCustoFailure(message: e.toString()));
    }
  }
}
