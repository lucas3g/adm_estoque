import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/usecases/get_product_by_id.dart';
import 'package:adm_estoque/app/modules/stock/domain/usecases/get_product_by_name.dart';
import 'package:adm_estoque/app/modules/stock/domain/usecases/upsert_stock.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/product/product_events.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/product/product_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductBloc extends Bloc<ProductEvents, ProductStates> {
  final GetProductByIdUseCase _getProductByIdUseCase;
  final UpsertStockUseCase _upsertStockUseCase;
  final GetProductByNameUseCase _getProductByNameUseCase;

  ProductBloc({
    required GetProductByIdUseCase getProductByIdUseCase,
    required UpsertStockUseCase upsertStockUseCase,
    required GetProductByNameUseCase getProductByNameUseCase,
  })  : _getProductByIdUseCase = getProductByIdUseCase,
        _upsertStockUseCase = upsertStockUseCase,
        _getProductByNameUseCase = getProductByNameUseCase,
        super(ProductInitialState()) {
    on<GetProductByIdEvent>(_getProductById);
    on<UpsertStockEvent>(_upsertStock);
    on<GetProductsByNameEvent>(_getProductsByName);
  }

  Future _getProductById(GetProductByIdEvent event, emit) async {
    emit(ProductLoadingState());

    final ProductArgs args = ProductArgs(id: event.id);

    final EitherOf<AppFailure, ProductEntity> result =
        await _getProductByIdUseCase(args);

    result.get(
      (AppFailure failure) => emit(ProductErrorState(message: failure.message)),
      (ProductEntity product) => emit(ProductSuccessState(product: product)),
    );
  }

  Future _upsertStock(UpsertStockEvent event, emit) async {
    emit(ProductLoadingState());

    final EitherOf<AppFailure, VoidSuccess> result =
        await _upsertStockUseCase(event.product);

    result.get(
      (AppFailure failure) => emit(ProductErrorState(message: failure.message)),
      (VoidSuccess success) => emit(UpsertStockSuccessState()),
    );
  }

  Future _getProductsByName(GetProductsByNameEvent event, emit) async {
    emit(ProductLoadingState());

    final EitherOf<AppFailure, List<ProductEntity>> result =
        await _getProductByNameUseCase(event.name);

    result.get(
      (AppFailure failure) => emit(ProductErrorState(message: failure.message)),
      (List<ProductEntity> products) =>
          emit(ProductsByNameSuccessState(products: products)),
    );
  }
}
