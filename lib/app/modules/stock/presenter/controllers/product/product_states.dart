import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';

sealed class ProductStates {}

class ProductInitialState extends ProductStates {}

class ProductLoadingState extends ProductStates {}

class ProductErrorState extends ProductStates {
  final String message;

  ProductErrorState({required this.message});
}

class ProductSuccessState extends ProductStates {
  final ProductEntity product;

  ProductSuccessState({required this.product});
}

class UpsertStockSuccessState extends ProductStates {
  UpsertStockSuccessState();
}

class ProductsByNameSuccessState extends ProductStates {
  final List<ProductEntity> products;

  ProductsByNameSuccessState({required this.products});
}
