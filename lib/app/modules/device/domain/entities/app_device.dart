import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';

class AppDeviceEntity {
  TextVO _deviceId;
  bool _active;

  TextVO get deviceId => _deviceId;
  void setDeviceId(String value) => _deviceId = TextVO(value);

  bool get active => _active;
  void setActive(bool value) => _active = value;

  AppDeviceEntity({
    required String deviceId,
    required bool active,
  })  : _deviceId = TextVO(deviceId),
        _active = active;

  factory AppDeviceEntity.entity(String deviceId) {
    return AppDeviceEntity(
      deviceId: deviceId,
      active: false,
    );
  }
}
