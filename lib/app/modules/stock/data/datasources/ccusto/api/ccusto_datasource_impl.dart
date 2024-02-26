import 'package:adm_estoque/app/core/data/clients/http/client_http.dart';
import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/response_entity.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/ccusto_datasource.dart';
import 'package:adm_estoque/app/modules/stock/domain/adapters/ccusto/ccusto_adapter.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto_failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CCustoDataSource)
class CCustoDataSourceImpl implements CCustoDataSource {
  final ClientHttp _clientHttp;

  CCustoDataSourceImpl({required ClientHttp clientHttp})
      : _clientHttp = clientHttp;

  @override
  Future<List<CCustoEntity>> getAllCCustos() async {
    try {
      _clientHttp.setHeaders(
          <String, dynamic>{'cnpj': AppGlobal.instance.user!.cnpj.value});

      final HttpResponseEntity<List<dynamic>> response =
          await _clientHttp.get(AppEndpoints.ccustos.path);

      final List<dynamic>? data = response.data;
      final int statusCode = response.statusCode;

      if (statusCode != 200 || data == null || data.isEmpty) {
        throw CCustoFailure(message: 'Erro ao buscar os centros de custo');
      }

      final List<CCustoEntity> listCCustos =
          List<Map<String, dynamic>>.from(data)
              .map(CCustoAdapter.fromJson)
              .toList();

      return listCCustos;
    } on AppFailure {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
