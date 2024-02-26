import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';

abstract class CCustoDataSource {
  Future<List<CCustoEntity>> getAllCCustos();
}
