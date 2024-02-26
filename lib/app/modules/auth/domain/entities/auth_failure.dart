import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class AuthFailure extends AppFailure {
  AuthFailure({String? message}) : super(message ?? 'auth.error.message');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AuthFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
