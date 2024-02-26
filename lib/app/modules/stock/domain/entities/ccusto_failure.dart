import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class CCustoFailure extends AppFailure {
  CCustoFailure({String? message}) : super(message ?? 'CCusto Error');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CCustoFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
