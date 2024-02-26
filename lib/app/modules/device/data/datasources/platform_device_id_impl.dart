import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/device/data/datasources/device_info_datasource.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/device_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:platform_device_id/platform_device_id.dart';

@Injectable(as: DeviceInfoDataSource)
class PlatformDeviceIdImpl implements DeviceInfoDataSource {
  @override
  Future<EitherOf<AppFailure, AppDeviceEntity>> getDeviceInfo() async {
    try {
      final String? deviceId = await PlatformDeviceId.getDeviceId;

      if (deviceId == null) {
        return reject(
          DeviceFailure(
            message: 'Id do dispositivo não encontrado',
          ),
        );
      }

      final AppDeviceEntity appDevice = AppDeviceEntity.entity(deviceId);

      return resolve(appDevice);
    } catch (e) {
      return reject(
        DeviceFailure(
          message: 'Erro ao buscar informações do dispositivo',
        ),
      );
    }
  }
}
