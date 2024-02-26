import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';

abstract class ConfigRepository {
  Future<EitherOf<AppFailure, VoidSuccess>> changeIpServerClientHttp(String ip);
}
