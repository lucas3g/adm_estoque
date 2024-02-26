// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductByNameUseCase implements UseCase<List<ProductEntity>, String> {
  final ProductRepository _productRepository;

  GetProductByNameUseCase({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  @override
  Future<EitherOf<AppFailure, List<ProductEntity>>> call(String args) {
    return _productRepository.getProductByName(name: args);
  }
}
