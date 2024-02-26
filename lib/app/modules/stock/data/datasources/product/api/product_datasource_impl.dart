import 'package:adm_estoque/app/core/data/clients/http/client_http.dart';
import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/response_entity.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/product_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/adapters/product/product_adapter.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product_failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDataSource)
class ProductDataSourceImpl implements ProductDataSource {
  final ClientHttp _clientHttp;

  ProductDataSourceImpl({required ClientHttp clientHttp})
      : _clientHttp = clientHttp;

  @override
  Future<ProductEntity> getProduct({required String id}) async {
    try {
      final [
        Map<String, dynamic> productDetails,
        Map<String, dynamic> productStock
      ] = await Future.wait(<Future<Map<String, dynamic>>>[
        _getProductDetails(id),
        _getProductStock(id, AppGlobal.instance.user!.ccusto.value),
      ]);

      final Map<String, dynamic> data = <String, dynamic>{
        ...productDetails,
        ...productStock,
      };

      return ProductAdapter.fromJson(data);
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getProductDetails(String id) async {
    try {
      _clientHttp.setHeaders(ProductAdapter.toJsonHeaderAPI(id, 'id'));

      final HttpResponseEntity<List<dynamic>> response =
          await _clientHttp.get(AppEndpoints.product.path);

      final dynamic data = response.data;
      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw ProductFailure(message: 'Erro ao buscar a mercadoria');
      }

      if (data == null || data.isEmpty) {
        throw ProductFailure(message: 'Mercadoria não encontrada!');
      }

      return data[0];
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getProductStock(String id, int ccusto) async {
    try {
      _clientHttp.setHeaders(ProductAdapter.toJsonStockHeaderAPI(ccusto));

      final HttpResponseEntity<dynamic> response =
          await _clientHttp.get('${AppEndpoints.stock.path}/$id');

      final dynamic data = response.data;
      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw ProductFailure(message: 'Erro ao buscar estoque da mercadoria');
      }

      if (data == null || data.isEmpty) {
        return <String, dynamic>{'QTD_NOVO': 0, 'QTD_ANTES': 0};
      }

      return data[0];
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> upsertStock({required ProductEntity product}) async {
    try {
      _clientHttp.setHeaders(
        ProductAdapter.toJsonStockHeaderAPI(
          AppGlobal.instance.user!.ccusto.value,
        ),
      );

      final Map<String, dynamic> jsonProduct = ProductAdapter.toJson(product);

      final HttpResponseEntity<dynamic> response = await _clientHttp.post(
        '${AppEndpoints.stock.path}/${product.id.value}',
        data: jsonProduct,
      );

      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw ProductFailure(
            message: 'Erro ao inserir / atualizar estoque da mercadoria');
      }

      return;
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductEntity>> getProductByName({required String name}) async {
    try {
      final List<Map<String, dynamic>> productsDetails =
          await _getProductsByName(name);

      for (final Map<String, dynamic> product in productsDetails) {
        final Map<String, dynamic> productStock = await _getProductStock(
          product['ID'],
          AppGlobal.instance.user!.ccusto.value,
        );

        product.addAll(productStock);
      }

      final List<ProductEntity> products =
          productsDetails.map<ProductEntity>(ProductAdapter.fromJson).toList();

      return products;
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _getProductsByName(String name) async {
    try {
      _clientHttp.setHeaders(ProductAdapter.toJsonHeaderAPI(name, 'DESCRICAO'));

      final HttpResponseEntity<List<dynamic>> response =
          await _clientHttp.get(AppEndpoints.product.path);

      final dynamic data = response.data;
      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw ProductFailure(message: 'Erro ao buscar a mercadoria');
      }

      if (data == null || data.isEmpty) {
        throw ProductFailure(message: 'Mercadoria não encontrada!');
      }

      return List<Map<String, dynamic>>.from(data);
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
