import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/device/data/repositories/device_info_repository_impl.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/device_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/device_fixture.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockDeviceInfoDataSource mockDeviceInfoDataSource;
  late DeviceInfoRepositoryImpl deviceInfoRepositoryImpl;

  setUp(() {
    mockDeviceInfoDataSource = MockDeviceInfoDataSource();
    deviceInfoRepositoryImpl =
        DeviceInfoRepositoryImpl(mockDeviceInfoDataSource);
  });

  test('should return a DeviceInfoEntity when call to datasource is successful',
      () async {
    when(mockDeviceInfoDataSource.getDeviceInfo()).thenAnswer(
      (_) async => resolve(DeviceFixture().deviceEntity()),
    );

    final EitherOf<AppFailure, AppDeviceEntity> response =
        await deviceInfoRepositoryImpl.getDeviceInfo();

    final Object result = response.get(id, id);

    expect(result, isA<AppDeviceEntity>());
  });

  test('should return a Failure when call to datasource returns a reject',
      () async {
    when(mockDeviceInfoDataSource.getDeviceInfo()).thenAnswer(
      (_) async => reject(DeviceFailure(message: 'Error')),
    );

    final EitherOf<AppFailure, AppDeviceEntity> response =
        await deviceInfoRepositoryImpl.getDeviceInfo();

    final Object result = response.get(id, id);

    expect(result, isA<AppFailure>());
  });
}
