import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/device_failure.dart';
import 'package:adm_estoque/app/modules/device/domain/usecases/get_device_info_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/device_fixture.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockDeviceInfoRepository mockDeviceInfoRepository;
  late GetDeviceInfoUseCase getDeviceInfoUseCase;

  setUp(() {
    mockDeviceInfoRepository = MockDeviceInfoRepository();
    getDeviceInfoUseCase = GetDeviceInfoUseCase(
      repository: mockDeviceInfoRepository,
    );
  });

  test('should return a DeviceInfoEntity when call to repository is successful',
      () async {
    final AppDeviceEntity device = DeviceFixture().deviceEntity();

    when(mockDeviceInfoRepository.getDeviceInfo()).thenAnswer(
      (_) async => resolve(device),
    );

    final EitherOf<AppFailure, AppDeviceEntity> response =
        await getDeviceInfoUseCase(const NoArgs());

    final Object result = response.get(id, id);

    expect(result, device);
  });

  test('should return Failure when call to respository returns a reject',
      () async {
    when(mockDeviceInfoRepository.getDeviceInfo()).thenAnswer(
      (_) async => reject(DeviceFailure(message: 'Error')),
    );

    final EitherOf<AppFailure, AppDeviceEntity> response =
        await getDeviceInfoUseCase(const NoArgs());

    final Object result = response.get(id, id);

    expect(result, isA<AppFailure>());
  });
}
