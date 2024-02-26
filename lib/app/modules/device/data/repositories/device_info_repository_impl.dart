import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/device/data/datasources/device_info_datasource.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DeviceInfoRepository)
class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DeviceInfoDataSource dataSource;

  DeviceInfoRepositoryImpl(this.dataSource);

  @override
  Future<EitherOf<AppFailure, AppDeviceEntity>> getDeviceInfo() async {
    return await dataSource.getDeviceInfo();
  }
}
