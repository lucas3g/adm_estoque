import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDeviceInfoUseCase implements UseCase<AppDeviceEntity, NoArgs> {
  final DeviceInfoRepository _repository;

  GetDeviceInfoUseCase({required DeviceInfoRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, AppDeviceEntity>> call(NoArgs args) async {
    return await _repository.getDeviceInfo();
  }
}
