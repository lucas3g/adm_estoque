import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';

sealed class ProductEvents {}

class GetProductByIdEvent extends ProductEvents {
  final String id;

  GetProductByIdEvent({required this.id});
}

class UpsertStockEvent extends ProductEvents {
  final ProductEntity product;

  UpsertStockEvent({required this.product});
}

class GetProductsByNameEvent extends ProductEvents {
  final String name;

  GetProductsByNameEvent({required this.name});
}
