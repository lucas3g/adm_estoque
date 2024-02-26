import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';

sealed class AuthEvents {}

class AuthInitLoginEvent extends AuthEvents {
  final UserEntity user;

  AuthInitLoginEvent({
    required this.user,
  });
}

class VerifyLicenseEvent extends AuthEvents {
  final String license;

  VerifyLicenseEvent({required this.license});
}

class LogoutEvent extends AuthEvents {}
