import 'package:adm_estoque/app/core/data/clients/http/client_http.dart';
import 'package:adm_estoque/app/modules/config/data/datasources/config_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ConfigDataSource)
class ConfigDataSourceImpl implements ConfigDataSource {
  final ClientHttp _clientHttp;

  ConfigDataSourceImpl({required ClientHttp clientHttp})
      : _clientHttp = clientHttp;

  @override
  Future<void> changeIpServerClientHttp(String ip) async {
    _clientHttp.setBaseUrl(ip);
  }
}
