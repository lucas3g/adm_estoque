// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i12;
import 'package:hive_flutter/hive_flutter.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i13;

import '../core/data/clients/http/client_http.dart' as _i16;
import '../core/data/clients/http/dio_http_client_impl.dart' as _i17;
import '../core/data/clients/local_database/hive_service.dart' as _i11;
import '../core/data/clients/local_database/local_database.dart' as _i10;
import '../core/data/clients/local_storage/local_storage.dart' as _i27;
import '../core/data/clients/local_storage/shared_preferences_service.dart'
    as _i28;
import '../database/data/datasources/database_datasource.dart' as _i22;
import '../database/data/datasources/database_datasource_impl.dart' as _i23;
import '../database/data/repositories/database_repository_impl.dart' as _i25;
import '../database/domain/repositories/database_repository.dart' as _i24;
import '../database/domain/usecases/populate_hive.dart' as _i29;
import '../modules/auth/data/datasources/auth_datasource.dart' as _i37;
import '../modules/auth/data/datasources/auth_datasource_impl.dart' as _i38;
import '../modules/auth/data/repositories/auth_repository_impl.dart' as _i40;
import '../modules/auth/domain/repositories/auth_repository.dart' as _i39;
import '../modules/auth/domain/usecases/auto_login.dart' as _i41;
import '../modules/auth/domain/usecases/login_with_cnpj_and_name_and_password.dart'
    as _i49;
import '../modules/auth/domain/usecases/logout.dart' as _i50;
import '../modules/auth/domain/usecases/verify_license.dart' as _i52;
import '../modules/auth/presenter/controller/auth_bloc.dart' as _i53;
import '../modules/config/data/datasources/config_datasource.dart' as _i18;
import '../modules/config/data/datasources/config_datasource_impl.dart' as _i19;
import '../modules/config/data/repositories/config_repository_impl.dart'
    as _i21;
import '../modules/config/domain/repositories/config_repository.dart' as _i20;
import '../modules/config/domain/usecases/change_ip_server_client_http.dart'
    as _i45;
import '../modules/device/data/datasources/device_info_datasource.dart' as _i3;
import '../modules/device/data/datasources/platform_device_id_impl.dart' as _i4;
import '../modules/device/data/repositories/device_info_repository_impl.dart'
    as _i6;
import '../modules/device/domain/repositories/device_info_repository.dart'
    as _i5;
import '../modules/device/domain/usecases/get_device_info_usecase.dart' as _i8;
import '../modules/device/presenter/bloc/device_info_bloc.dart' as _i26;
import '../modules/stock/data/datasources/ccusto/api/ccusto_datasource_impl.dart'
    as _i42;
import '../modules/stock/data/datasources/ccusto/ccusto_datasource.dart'
    as _i14;
import '../modules/stock/data/datasources/ccusto/local/ccusto_datasource_local_impl.dart'
    as _i15;
import '../modules/stock/data/datasources/product/api/product_datasource_impl.dart'
    as _i31;
import '../modules/stock/data/datasources/product/product_datasource.dart'
    as _i30;
import '../modules/stock/data/repositories/ccusto_repository_impl.dart' as _i44;
import '../modules/stock/data/repositories/product_repository_impl.dart'
    as _i33;
import '../modules/stock/domain/repositories/ccusto_repository.dart' as _i43;
import '../modules/stock/domain/repositories/product_repository.dart' as _i32;
import '../modules/stock/domain/usecases/get_all_ccustos.dart' as _i46;
import '../modules/stock/domain/usecases/get_product_by_id.dart' as _i47;
import '../modules/stock/domain/usecases/get_product_by_name.dart' as _i48;
import '../modules/stock/domain/usecases/upsert_stock.dart' as _i34;
import '../modules/stock/presenter/controllers/ccusto/ccusto_bloc.dart' as _i54;
import '../modules/stock/presenter/controllers/product/product_bloc.dart'
    as _i51;
import '../modules/user/data/datasources/local/shared_prefs_local_datasource_impl.dart'
    as _i36;
import '../modules/user/data/datasources/local/user_local_datasource.dart'
    as _i35;
import 'dependency_injection.dart' as _i55;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.DeviceInfoDataSource>(() => _i4.PlatformDeviceIdImpl());
    gh.factory<_i5.DeviceInfoRepository>(
        () => _i6.DeviceInfoRepositoryImpl(gh<_i3.DeviceInfoDataSource>()));
    gh.factory<_i7.Dio>(() => registerModule.dio);
    gh.factory<_i8.GetDeviceInfoUseCase>(() =>
        _i8.GetDeviceInfoUseCase(repository: gh<_i5.DeviceInfoRepository>()));
    gh.factory<_i9.HiveInterface>(() => registerModule.hive);
    gh.factory<_i10.LocalDatabase>(
        () => _i11.HiveService(hive: gh<_i12.HiveInterface>()));
    await gh.factoryAsync<_i13.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i14.CCustoDataSource>(
      () => _i15.CCustoDataSourceLocalImpl(
          localDatabase: gh<_i10.LocalDatabase>()),
      instanceName: 'CCustoDataSourceLocalImpl',
    );
    gh.singleton<_i16.ClientHttp>(_i17.DioClientHttpImpl(dio: gh<_i7.Dio>()));
    gh.factory<_i18.ConfigDataSource>(
        () => _i19.ConfigDataSourceImpl(clientHttp: gh<_i16.ClientHttp>()));
    gh.factory<_i20.ConfigRepository>(() => _i21.ConfigRepositoryImpl(
        configDataSource: gh<_i18.ConfigDataSource>()));
    gh.factory<_i22.DatabaseDatasource>(() =>
        _i23.DatabaseDatasourceImpl(localDatabase: gh<_i10.LocalDatabase>()));
    gh.factory<_i24.DatabaseRepository>(() => _i25.DatabaseRepositoryImpl(
        databaseDatasource: gh<_i22.DatabaseDatasource>()));
    gh.singleton<_i26.DeviceInfoBloc>(_i26.DeviceInfoBloc(
        getDeviceInfoUseCase: gh<_i8.GetDeviceInfoUseCase>()));
    gh.factory<_i27.LocalStorage>(() => _i28.SharedPreferencesService(
        preferences: gh<_i13.SharedPreferences>()));
    gh.factory<_i29.PopulateHiveUseCase>(() =>
        _i29.PopulateHiveUseCase(repository: gh<_i24.DatabaseRepository>()));
    gh.factory<_i30.ProductDataSource>(
        () => _i31.ProductDataSourceImpl(clientHttp: gh<_i16.ClientHttp>()));
    gh.factory<_i32.ProductRepository>(() => _i33.ProductRepositoryImpl(
        productDataSource: gh<_i30.ProductDataSource>()));
    gh.factory<_i34.UpsertStockUseCase>(() => _i34.UpsertStockUseCase(
        productRepository: gh<_i32.ProductRepository>()));
    gh.factory<_i35.UserLocalDataSource>(() =>
        _i36.SharedPrefsUserLocalDatasourceImpl(
            localStorage: gh<_i27.LocalStorage>()));
    gh.factory<_i37.AuthDatasource>(() => _i38.AuthDatasourceImpl(
          clientHttp: gh<_i16.ClientHttp>(),
          storageDatasource: gh<_i35.UserLocalDataSource>(),
        ));
    gh.factory<_i39.AuthRepository>(() =>
        _i40.AuthRepositoryImpl(authDatasource: gh<_i37.AuthDatasource>()));
    gh.factory<_i41.AutoLoginUsecase>(
        () => _i41.AutoLoginUsecase(authRepository: gh<_i39.AuthRepository>()));
    gh.factory<_i14.CCustoDataSource>(
        () => _i42.CCustoDataSourceImpl(clientHttp: gh<_i16.ClientHttp>()));
    gh.factory<_i43.CCustoRepository>(() => _i44.CCustoRepositoryImpl(
        ccustoDataSource: gh<_i14.CCustoDataSource>()));
    gh.factory<_i45.ChangeIpServerClientHttpUseCase>(() =>
        _i45.ChangeIpServerClientHttpUseCase(
            configRepository: gh<_i20.ConfigRepository>()));
    gh.factory<_i46.GetAllCustosUseCase>(() => _i46.GetAllCustosUseCase(
        ccustoRepository: gh<_i43.CCustoRepository>()));
    gh.factory<_i47.GetProductByIdUseCase>(() => _i47.GetProductByIdUseCase(
        productRepository: gh<_i32.ProductRepository>()));
    gh.factory<_i48.GetProductByNameUseCase>(() => _i48.GetProductByNameUseCase(
        productRepository: gh<_i32.ProductRepository>()));
    gh.factory<_i49.LoginWithCnpjAndNameAndPasswordUsecase>(() =>
        _i49.LoginWithCnpjAndNameAndPasswordUsecase(
            authRepository: gh<_i39.AuthRepository>()));
    gh.factory<_i50.LogoutUsecase>(
        () => _i50.LogoutUsecase(authRepository: gh<_i39.AuthRepository>()));
    gh.factory<_i51.ProductBloc>(() => _i51.ProductBloc(
          getProductByIdUseCase: gh<_i47.GetProductByIdUseCase>(),
          upsertStockUseCase: gh<_i34.UpsertStockUseCase>(),
          getProductByNameUseCase: gh<_i48.GetProductByNameUseCase>(),
        ));
    gh.factory<_i52.VerifyLicenseUseCase>(
        () => _i52.VerifyLicenseUseCase(repository: gh<_i39.AuthRepository>()));
    gh.factory<_i53.AuthBloc>(() => _i53.AuthBloc(
          verifyLicenseUseCase: gh<_i52.VerifyLicenseUseCase>(),
          loginWithCnpjAndNameAndPasswordUsecase:
              gh<_i49.LoginWithCnpjAndNameAndPasswordUsecase>(),
          logoutUsecase: gh<_i50.LogoutUsecase>(),
        ));
    gh.factory<_i54.CCustoBloc>(() =>
        _i54.CCustoBloc(getAllCustosUseCase: gh<_i46.GetAllCustosUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i55.RegisterModule {}
