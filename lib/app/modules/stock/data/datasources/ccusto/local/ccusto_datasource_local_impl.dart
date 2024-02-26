import 'package:adm_estoque/app/core/data/clients/local_database/local_database.dart';
import 'package:adm_estoque/app/core/data/clients/local_database/params/database_params.dart';
import 'package:adm_estoque/app/core/domain/entities/database_keys.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/ccusto_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/adapters/ccusto/ccusto_adapter.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto_failure.dart';
import 'package:injectable/injectable.dart';

@Named('CCustoDataSourceLocalImpl')
@LazySingleton(as: CCustoDataSource)
class CCustoDataSourceLocalImpl implements CCustoDataSource {
  final LocalDatabase _localDatabase;

  CCustoDataSourceLocalImpl({required LocalDatabase localDatabase})
      : _localDatabase = localDatabase;

  @override
  Future<List<CCustoEntity>> getAllCCustos() async {
    try {
      final DatabaseParams param = DatabaseParams(table: DatabaseKeys.ccustos);

      final List<dynamic>? ccustos =
          await _localDatabase.getData(params: param);

      if (ccustos != null) {
        return List<CCustoEntity>.from(
          ccustos.map(CCustoAdapter.fromJson).toList(),
        );
      }

      throw CCustoFailure(message: 'Erro ao buscar os centros de custos');
    } catch (e) {
      throw CCustoFailure(message: 'Erro ao buscar os centros de custos');
    }
  }
}
