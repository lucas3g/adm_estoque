import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class DatabaseFailure extends AppFailure {
  DatabaseFailure({String? message}) : super(message ?? 'auth.error.message');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DatabaseFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
