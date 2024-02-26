import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/device/domain/entities/app_device.dart';
import 'package:adm_estoque/app/modules/device/domain/usecases/get_device_info_usecase.dart';
import 'package:adm_estoque/app/modules/device/presenter/bloc/device_info_events.dart';
import 'package:adm_estoque/app/modules/device/presenter/bloc/device_info_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class DeviceInfoBloc extends Bloc<DeviceInfoEvents, DeviceInfoStates> {
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;

  DeviceInfoBloc({required GetDeviceInfoUseCase getDeviceInfoUseCase})
      : _getDeviceInfoUseCase = getDeviceInfoUseCase,
        super(DeviceInfoInitial()) {
    on<GetDeviceInfoEvent>(_getDeviceInfo);
  }

  Future _getDeviceInfo(GetDeviceInfoEvent event, emit) async {
    emit(state.loading());

    final EitherOf<AppFailure, AppDeviceEntity> result = await _getDeviceInfoUseCase.call(const NoArgs());

    result.get(
      (AppFailure failure) => emit(state.error(failure.message)),
      (AppDeviceEntity appDeviceEntity) => emit(state.success(appDeviceEntity)),
    );
  }
}
