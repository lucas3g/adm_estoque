import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';

sealed class DeviceInfoStates {
  final AppDeviceEntity? appDeviceEntity;

  const DeviceInfoStates({this.appDeviceEntity});

  DeviceInfoStates loading() => DeviceInfoLoading();

  DeviceInfoStates success(AppDeviceEntity appDeviceEntity) =>
      DeviceInfoSuccess(appDeviceEntity);

  DeviceInfoStates error(String message) => DeviceInfoError(message);
}

class DeviceInfoInitial extends DeviceInfoStates {
  DeviceInfoInitial() : super(appDeviceEntity: null);
}

class DeviceInfoLoading extends DeviceInfoStates {
  DeviceInfoLoading() : super(appDeviceEntity: null);
}

class DeviceInfoSuccess extends DeviceInfoStates {
  DeviceInfoSuccess(AppDeviceEntity appDeviceEntity)
      : super(appDeviceEntity: appDeviceEntity);
}

class DeviceInfoError extends DeviceInfoStates {
  final String message;

  DeviceInfoError(this.message) : super(appDeviceEntity: null);
}
