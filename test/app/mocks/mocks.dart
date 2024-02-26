import 'dart:async';

import 'package:adm_estoque/app/core/data/clients/http/client_http.dart';
import 'package:adm_estoque/app/core/data/clients/local_storage/local_storage.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/app_mode.dart';
import 'package:adm_estoque/app/modules/auth/data/datasources/auth_datasource.dart';
import 'package:adm_estoque/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/login_with_cnpj_and_name_and_password.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/logout.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/verify_license.dart';
import 'package:adm_estoque/app/modules/device/data/datasources/device_info_datasource.dart';
import 'package:adm_estoque/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:adm_estoque/app/modules/device/domain/usecases/get_device_info_usecase.dart';
import 'package:adm_estoque/app/modules/user/data/datasources/local/user_local_datasource.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks(<Type>[
  //[GLOBAL]
  Dio,
  ClientHttp,
  SharedPreferences,
  LocalStorage,
  UserLocalDataSource,
  UserEntity,

  //[AUTH]
  AuthDatasource,
  AuthRepository,
  LoginWithCnpjAndNameAndPasswordUsecase,
  LogoutUsecase,
  VerifyLicenseUseCase,

  // [DEVICE]
  DeviceInfoDataSource,
  DeviceInfoRepository,
  GetDeviceInfoUseCase,
])
class Mocks {
  void initializeFakeAppGlobal() {
    AppGlobal(
      baseUrl: 'http://192.168.254.200:9000',
      baseUrlLicense: const String.fromEnvironment('BASE_URL_LICENSE'),
      appMode: StreamController<AppMode>.broadcast(),
    );
  }
}
