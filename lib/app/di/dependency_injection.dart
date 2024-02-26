import 'dart:async';

import 'package:adm_estoque/app/core/data/clients/local_storage/local_storage.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/app_mode.dart';
import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/storage_keys.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';
import 'package:adm_estoque/app/database/domain/usecases/populate_hive.dart';
import 'package:adm_estoque/app/di/dependency_injection.config.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/auto_login.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/verify_license.dart';
import 'package:adm_estoque/app/modules/config/presenter/config_page.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/usecases/get_device_info_usecase.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/api/ccusto_datasource_impl.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/ccusto_datasource.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/ccusto/local/ccusto_datasource_local_impl.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/api/product_datasource_impl.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/local/product_datasource_local_impl.dart';
import 'package:adm_estoque/app/modules/stock/data/datasources/product/product_datasource.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  await getIt.init();

  await _initModeListener();

  final UserEntity? user = await _tryAutoLogin();
  final bool hasIpServer = await _verifyIpServer();
  final bool hasDevice = await _getDeviceInfo();

  if (user != null && hasIpServer && hasDevice) {
    await _verifyDependenciesRegistered();
    _registerDependeciesOnline();

    await _readOpenCamera();
    await _verifyLicense();
  }
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Dio get dio => _dioFactory();

  HiveInterface get hive => Hive;
}

Dio _dioFactory() {
  final BaseOptions baseOptions = BaseOptions(
    headers: <String, dynamic>{'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );

  return Dio(baseOptions);
}

void _initAppGlobal() {
  AppGlobal(
    baseUrl: '',
    baseUrlLicense: const String.fromEnvironment('BASE_URL_LICENSE'),
    user: null,
    device: null,
    typeStock: TypeStock.contabil,
    openCameraWhenUpsertStock: false,
    appMode: StreamController<AppMode>.broadcast(),
  );
}

Future<UserEntity?> _tryAutoLogin() async {
  final AutoLoginUsecase autoLoginUsecase = getIt<AutoLoginUsecase>();

  final EitherOf<AppFailure, UserEntity?> response =
      await autoLoginUsecase(const NoArgs());

  final Object? result = response.get(
    (AppFailure reject) => reject,
    (UserEntity? resolve) => resolve,
  );

  if (result is UserEntity) {
    AppGlobal.instance.setUser(result);

    return result;
  }

  return null;
}

Future<bool> _verifyIpServer() async {
  final LocalStorage prefs = getIt<LocalStorage>();

  final String? ipServer = await prefs.getData(StorageKeys.ipServer);

  if (ipServer != null) {
    AppGlobal.instance.setBaseUrl(ipServer);

    return true;
  }

  return false;
}

Future<bool> _getDeviceInfo() async {
  final GetDeviceInfoUseCase getDeviceInfoUseCase =
      getIt<GetDeviceInfoUseCase>();

  final EitherOf<AppFailure, AppDeviceEntity> deviceResult =
      await getDeviceInfoUseCase(const NoArgs());

  final Object? result = deviceResult.get(
    (AppFailure reject) => reject,
    (AppDeviceEntity resolve) => resolve,
  );

  if (result is AppDeviceEntity) {
    AppGlobal.instance.setDevice(result);

    return true;
  }

  return false;
}

Future<void> _verifyLicense() async {
  final VerifyLicenseUseCase verifyLicenseUseCase =
      getIt<VerifyLicenseUseCase>();

  final VerifyLicenseUseCaseArgs args = VerifyLicenseUseCaseArgs(
    license: AppGlobal.instance.device!.deviceId.value,
  );

  await verifyLicenseUseCase(args);
}

Future<void> _initHive() async {
  await Hive.initFlutter();
}

Future<void> _readOpenCamera() async {
  final LocalStorage prefs = getIt<LocalStorage>();

  final String? openCamera = await prefs.getData(StorageKeys.openCamera);

  if (openCamera != null) {
    AppGlobal.instance.setOpenCameraWhenUpsertStock(openCamera == 'S');
  }
}

Future<void> _populateHiveDB() async {
  final PopulateHiveUseCase populateHiveUseCase = getIt<PopulateHiveUseCase>();

  await populateHiveUseCase(const NoArgs());
}

void _persistFakeUser() {
  AppGlobal.instance.setUser(
    UserEntity(
      id: const TextVO('1'),
      username: 'Fake User',
      ccusto: 1,
    ),
  );
}

Future<void> _verifyDependenciesRegistered() async {
  if (getIt.isRegistered<CCustoDataSource>()) {
    await getIt.unregister<CCustoDataSource>();
  }

  if (getIt.isRegistered<ProductDataSource>()) {
    await getIt.unregister<ProductDataSource>();
  }
}

void _registerDependeciesOnline() {
  getIt.registerFactory<CCustoDataSource>(
    () => CCustoDataSourceImpl(
      clientHttp: getIt(),
    ),
  );

  getIt.registerFactory<ProductDataSource>(
    () => ProductDataSourceImpl(
      clientHttp: getIt(),
    ),
  );
}

void _registerDependeciesLocal() {
  getIt.registerFactory<CCustoDataSource>(
    () => CCustoDataSourceLocalImpl(
      localDatabase: getIt(),
    ),
  );

  getIt.registerFactory<ProductDataSource>(
    () => ProductDataSourceLocalImpl(
      localDatabase: getIt(),
    ),
  );
}

Future<void> _initModeListener() async {
  AppGlobal.instance.appMode.stream.listen((AppMode mode) async {
    await _verifyDependenciesRegistered();

    switch (mode) {
      case AppMode.demo:
        await _initHive();

        await _populateHiveDB();

        _persistFakeUser();

        _registerDependeciesLocal();

        break;
      default:
        _registerDependeciesOnline();
        break;
    }
  });
}
