import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';

abstract class ProductRepository {
  Future<EitherOf<AppFailure, ProductEntity>> getProduct({required String id});
  Future<EitherOf<AppFailure, VoidSuccess>> upsertStock(
      {required ProductEntity product});
  Future<EitherOf<AppFailure, List<ProductEntity>>> getProductByName(
      {required String name});
}
