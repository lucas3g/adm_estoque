import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';

class DeviceFixture {
  AppDeviceEntity deviceEntity() {
    return AppDeviceEntity(
      deviceId: '123',
      active: false,
    );
  }
}
