import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class ConfigFailure extends AppFailure {
  final dynamic error;

  ConfigFailure({
    String? message,
    this.error,
  }) : super(message ?? 'Erro ao buscar informações de configuração do app');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConfigFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
