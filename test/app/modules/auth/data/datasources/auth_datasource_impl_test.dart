import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/core/domain/entities/response_entity.dart';
import 'package:adm_estoque/app/modules/auth/data/datasources/auth_datasource_impl.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/user_fixture.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockClientHttp mockClientHttp;
  late MockUserLocalDataSource mockUserLocalDataSource;
  late AuthDatasourceImpl authDatasourceImpl;

  setUp(() {
    mockClientHttp = MockClientHttp();
    mockUserLocalDataSource = MockUserLocalDataSource();
    authDatasourceImpl = AuthDatasourceImpl(
      clientHttp: mockClientHttp,
      storageDatasource: mockUserLocalDataSource,
    );
  });

  test('should return a UserEntity when call to datasource is successful',
      () async {
    final Map<String, dynamic> userJson = UserFixture().userJson();

    final UserEntity user = UserFixture().userEntity();

    when(mockClientHttp.setBaseUrl('http://192.168.212:9000'))
        .thenAnswer((_) {});

    when(
      mockClientHttp.post(
        AppEndpoints.login.path,
        data: userJson,
      ),
    ).thenAnswer(
      (_) async => HttpResponseEntity<Map<String, dynamic>>(
        statusCode: 200,
        data: userJson,
      ),
    );

    final UserEntity response =
        await authDatasourceImpl.loginWithCnpjAndNameAndPassword(user: user);

    expect(response, isA<UserEntity>());
  });
}
