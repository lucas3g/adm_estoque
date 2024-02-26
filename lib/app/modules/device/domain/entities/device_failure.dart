import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class DeviceFailure extends AppFailure {
  final dynamic error;

  DeviceFailure({
    String? message,
    this.error,
  }) : super(message ?? 'Erro ao buscar informações do dispositivo');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DeviceFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
