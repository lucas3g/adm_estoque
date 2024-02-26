import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/product_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product_failure.dart';
import 'package:adm_estoque/app/modules/stock/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepositoryImpl({
    required ProductDataSource productDataSource,
  }) : _productDataSource = productDataSource;

  @override
  Future<EitherOf<AppFailure, ProductEntity>> getProduct(
      {required String id}) async {
    try {
      final ProductEntity result = await _productDataSource.getProduct(id: id);

      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(ProductFailure(message: e.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> upsertStock(
      {required ProductEntity product}) async {
    try {
      await _productDataSource.upsertStock(product: product);

      return resolve(const VoidSuccess());
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(ProductFailure(message: e.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, List<ProductEntity>>> getProductByName(
      {required String name}) async {
    try {
      final List<ProductEntity> result =
          await _productDataSource.getProductByName(name: name);

      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(ProductFailure(message: e.toString()));
    }
  }
}
