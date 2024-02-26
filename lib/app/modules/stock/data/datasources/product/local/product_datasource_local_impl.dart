import 'package:adm_estoque/app/core/data/clients/local_database/local_database.dart';
import 'package:adm_estoque/app/core/data/clients/local_database/params/database_params.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/product_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/adapters/product/product_adapter.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product_failure.dart';

class ProductDataSourceLocalImpl implements ProductDataSource {
  final LocalDatabase _localDatabase;

  ProductDataSourceLocalImpl({required LocalDatabase localDatabase})
      : _localDatabase = localDatabase;

  @override
  Future<ProductEntity> getProduct({required String id}) async {
    final DatabaseParams param = DatabaseParams(
      table: 'products',
      key: id,
    );

    final dynamic result = await _localDatabase.getData(params: param);

    if (result != null) {
      return ProductAdapter.fromJson(result);
    }

    throw ProductFailure(message: 'Erro ao buscar a mercadoria');
  }

  @override
  Future<List<ProductEntity>> getProductByName({required String name}) {
    throw ProductFailure(
      message: 'Operação não permitida para modo de demonstração!',
    );
  }

  @override
  Future<void> upsertStock({required ProductEntity product}) {
    throw ProductFailure(
      message: 'Operação não permitida para modo de demonstração!',
    );
  }
}
