import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/auth/domain/entities/auth_failure.dart';
import 'package:adm_estoque/app/modules/auth/domain/usecases/login_with_cnpj_and_name_and_password.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/user_fixture.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late LoginWithCnpjAndNameAndPasswordUsecase
      loginWithCnpjAndNameAndPasswordUsecase;

  setUp(
    () => <Object>{
      authRepository = MockAuthRepository(),
      loginWithCnpjAndNameAndPasswordUsecase =
          LoginWithCnpjAndNameAndPasswordUsecase(
        authRepository: authRepository,
      ),
    },
  );

  test('should return UserEntity when call to repository is successful',
      () async {
    final UserEntity user = UserFixture().userEntity();

    when(authRepository.loginWithCnpjAndNameAndPassword(user: user)).thenAnswer(
      (_) async => resolve(user),
    );

    final EitherOf<AppFailure, UserEntity> response =
        await loginWithCnpjAndNameAndPasswordUsecase(user);

    final Object result = response.get(id, id);

    expect(result, UserFixture().userEntity());
    expect(result, isA<UserEntity>());
  });

  test('should return Failure when call to respository returns a reject',
      () async {
    final UserEntity user = UserFixture().userEntity();

    when(authRepository.loginWithCnpjAndNameAndPassword(user: user)).thenAnswer(
      (_) async => reject(AuthFailure(message: 'Error')),
    );

    final EitherOf<AppFailure, UserEntity> response =
        await loginWithCnpjAndNameAndPasswordUsecase(user);

    final Object result = response.get(id, id);

    expect(result, isA<AppFailure>());
  });
}
