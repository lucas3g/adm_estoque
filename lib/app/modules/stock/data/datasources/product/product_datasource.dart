import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';

abstract class ProductDataSource {
  Future<ProductEntity> getProduct({required String id});
  Future<void> upsertStock({required ProductEntity product});
  Future<List<ProductEntity>> getProductByName({required String name});
}
