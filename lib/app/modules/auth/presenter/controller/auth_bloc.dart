import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/login_with_cnpj_and_name_and_password.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/logout.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/verify_license.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_events.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_states.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final VerifyLicenseUseCase _verifyLicenseUseCase;
  final LoginWithCnpjAndNameAndPasswordUsecase
      _loginWithCnpjAndNameAndPasswordUsecase;
  final LogoutUsecase _logoutUsecase;

  AuthBloc({
    required VerifyLicenseUseCase verifyLicenseUseCase,
    required LoginWithCnpjAndNameAndPasswordUsecase
        loginWithCnpjAndNameAndPasswordUsecase,
    required LogoutUsecase logoutUsecase,
  })  : _verifyLicenseUseCase = verifyLicenseUseCase,
        _loginWithCnpjAndNameAndPasswordUsecase =
            loginWithCnpjAndNameAndPasswordUsecase,
        _logoutUsecase = logoutUsecase,
        super(AuthInitial()) {
    on<VerifyLicenseEvent>(_verifyLicense);
    on<AuthInitLoginEvent>(_authLogin);
    on<LogoutEvent>(_logout);
  }

  Future<void> _verifyLicense(
      VerifyLicenseEvent event, Emitter<AuthStates> emit) async {
    emit(AuthLoading());

    final EitherOf<AppFailure, VoidSuccess> result =
        await _verifyLicenseUseCase(
      VerifyLicenseUseCaseArgs(
        license: event.license,
      ),
    );

    result.get((AppFailure failure) {
      if (failure.message.contains('Licença não encontrada!')) {
        return emit(LicenseNoData());
      }

      return emit(LicenseError(failure.message));
    }, (_) {
      if (AppGlobal.instance.device!.active) {
        return emit(LicenseActive());
      }
      if (!AppGlobal.instance.device!.active) {
        return emit(LicenseInactive());
      }

      return emit(LicenseNoData());
    });
  }

  Future<void> _authLogin(
      AuthInitLoginEvent event, Emitter<AuthStates> emit) async {
    final EitherOf<AppFailure, UserEntity> result =
        await _loginWithCnpjAndNameAndPasswordUsecase(event.user);

    await Future<void>.delayed(const Duration(milliseconds: 600));

    result.get(
      (AppFailure failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthStates> emit) async {
    emit(LogoutLoading());

    final EitherOf<AppFailure, VoidSuccess> result =
        await _logoutUsecase(const NoArgs());

    await Future<void>.delayed(const Duration(milliseconds: 600));

    result.get(
      (AppFailure failure) => emit(AuthError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
