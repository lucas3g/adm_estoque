import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';

abstract class DeviceInfoRepository {
  Future<EitherOf<AppFailure, AppDeviceEntity>> getDeviceInfo();
}
