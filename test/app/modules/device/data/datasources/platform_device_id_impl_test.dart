import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/device/data/datasources/platform_device_id_impl.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PlatformDeviceIdImpl platformDeviceIdImpl;

  setUp(() {
    platformDeviceIdImpl = PlatformDeviceIdImpl();
  });

  test('should return a String when call to datasource is successful',
      () async {
    final EitherOf<AppFailure, AppDeviceEntity> response =
        await platformDeviceIdImpl.getDeviceInfo();

    final Object result = response.get(id, id);

    expect(result, isA<AppDeviceEntity>());
  });
}
