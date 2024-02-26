import 'package:adm_estoque/app/core/data/clients/local_database/local_database.dart';
import 'package:adm_estoque/app/core/data/clients/local_database/params/database_params.dart';
import 'package:adm_estoque/app/core/domain/entities/database_keys.dart';
import 'package:adm_estoque/app/database/data/datasources/database_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DatabaseDatasource)
class DatabaseDatasourceImpl implements DatabaseDatasource {
  final LocalDatabase _localDatabase;

  DatabaseDatasourceImpl({required LocalDatabase localDatabase})
      : _localDatabase = localDatabase;

  @override
  Future<bool> populateHive() async {
    await Future.wait(<Future<bool>>[
      _setCCustos(),
      _setProducts(),
    ]);

    return true;
  }

  Future<bool> _setCCustos() async {
    final DatabaseParams matriz = DatabaseParams(
      table: DatabaseKeys.ccustos,
      key: 'matriz',
      value: <String, Object>{'ID': 1, 'DESCRICAO': 'MATRIZ'},
    );

    final DatabaseParams filial = DatabaseParams(
      table: DatabaseKeys.ccustos,
      key: 'filial',
      value: <String, Object>{'ID': 2, 'DESCRICAO': 'FILIAL'},
    );

    return await _localDatabase.setData(params: matriz) &&
        await _localDatabase.setData(params: filial);
  }

  Future<bool> _setProducts() async {
    final DatabaseParams coca = DatabaseParams(
      table: DatabaseKeys.products,
      key: '3638',
      value: <String, dynamic>{
        'ID': '3638',
        'DESCRICAO': 'COCA-COLA',
        'GTIN': '789745465',
        'QTD_NOVO': 1,
        'QTD_ANTES': 0,
      },
    );

    final DatabaseParams fanta = DatabaseParams(
      table: DatabaseKeys.products,
      key: '619',
      value: <String, dynamic>{
        'ID': '619',
        'DESCRICAO': 'FANTA UVA',
        'GTIN': '554564',
        'QTD_NOVO': 5,
        'QTD_ANTES': 0,
      },
    );

    return await _localDatabase.setData(params: coca) &&
        await _localDatabase.setData(params: fanta);
  }
}
