sealed class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {}

class AuthError extends AuthStates {
  final String message;

  AuthError(this.message);
}

class LicenseActive extends AuthStates {}

class LicenseInactive extends AuthStates {}

class LicenseNoData extends AuthStates {}

class LicenseError extends AuthStates {
  final String message;

  LicenseError(this.message);
}

class LogoutLoading extends AuthStates {}

class LogoutSuccess extends AuthStates {}
