import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';

abstract class CCustoRepository {
  Future<EitherOf<AppFailure, List<CCustoEntity>>> getAllCCustos();
}
