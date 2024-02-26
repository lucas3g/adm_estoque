import 'dart:async';

import 'package:adm_estoque/app/core/domain/entities/app_mode.dart';
import 'package:adm_estoque/app/modules/config/presenter/config_page.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';

class AppGlobal {
  String baseUrl;
  final String baseUrlLincese;
  UserEntity? user;
  AppDeviceEntity? device;
  TypeStock? typeStock;
  bool openCameraWhenUpsertStock;
  StreamController<AppMode> appMode;

  static late AppGlobal _instance;

  static AppGlobal get instance => _instance;

  factory AppGlobal({
    required String baseUrl,
    required String baseUrlLicense,
    UserEntity? user,
    AppDeviceEntity? device,
    TypeStock? typeStock,
    bool openCameraWhenUpsertStock = false,
    required StreamController<AppMode> appMode,
  }) {
    _instance = AppGlobal._internal(
      baseUrl,
      baseUrlLicense,
      user,
      device,
      typeStock,
      openCameraWhenUpsertStock,
      appMode,
    );

    return _instance;
  }

  AppGlobal._internal(
    this.baseUrl,
    this.baseUrlLincese,
    this.user,
    this.device,
    this.typeStock,
    this.openCameraWhenUpsertStock,
    this.appMode,
  );

  void setBaseUrl(String baseUrlParam) => baseUrl = baseUrlParam;

  void setUser(UserEntity? userParam) => user = userParam;

  void setDevice(AppDeviceEntity? deviceParam) => device = deviceParam;

  void setTypeStock(TypeStock typeStockParam) => typeStock = typeStockParam;

  void setOpenCameraWhenUpsertStock(bool openCameraWhenUpsertStockParam) =>
      openCameraWhenUpsertStock = openCameraWhenUpsertStockParam;
}
