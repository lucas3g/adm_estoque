import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:adm_estoque/app/modules/auth/domain/entities/auth_failure.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/user_fixture.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthDatasource mockAuthDatasource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthDatasource = MockAuthDatasource();
    authRepositoryImpl = AuthRepositoryImpl(
      authDatasource: mockAuthDatasource,
    );
  });

  test('should return a UserEntity when call to datasource is successful',
      () async {
    final UserEntity user = UserFixture().userEntity();

    when(mockAuthDatasource.loginWithCnpjAndNameAndPassword(user: user))
        .thenAnswer((_) async => user);

    final EitherOf<AppFailure, UserEntity> response =
        await authRepositoryImpl.loginWithCnpjAndNameAndPassword(
      user: user,
    );

    final Object result = response.get(id, id);

    expect(result, isA<UserEntity>());
  });

  test('should return a Failure when call to datasource returns a reject',
      () async {
    final UserEntity user = UserFixture().userEntity();

    when(mockAuthDatasource.loginWithCnpjAndNameAndPassword(user: user))
        .thenThrow((_) async => AuthFailure(message: 'Error'));

    final EitherOf<AppFailure, UserEntity> response =
        await authRepositoryImpl.loginWithCnpjAndNameAndPassword(
      user: user,
    );

    final Object result = response.get(id, id);

    expect(result, isA<AppFailure>());
  });
}
