import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/config/data/datasources/config_datasource.dart';
import 'package:adm_estoque/app/modules/config/domain/entities/config_failure.dart';
import 'package:adm_estoque/app/modules/config/domain/repositories/config_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ConfigRepository)
class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigDataSource _configDataSource;

  ConfigRepositoryImpl({required ConfigDataSource configDataSource})
      : _configDataSource = configDataSource;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> changeIpServerClientHttp(
      String ip) async {
    try {
      await _configDataSource.changeIpServerClientHttp(ip);

      return resolve(const VoidSuccess());
    } catch (e) {
      return reject(ConfigFailure(message: 'Erro ao alterar o IP do servidor'));
    }
  }
}
