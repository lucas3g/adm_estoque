import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpsertStockUseCase implements UseCase<VoidSuccess, ProductEntity> {
  final ProductRepository _productRepository;

  UpsertStockUseCase({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(ProductEntity product) async {
    return await _productRepository.upsertStock(product: product);
  }
}
