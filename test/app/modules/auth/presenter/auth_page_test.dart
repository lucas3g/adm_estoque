import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/auth/presenter/auth_page.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/mocks.mocks.dart';

void main() {
  late MockLoginWithCnpjAndNameAndPasswordUsecase
      mockLoginWithCnpjAndNameAndPasswordUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockVerifyLicenseUseCase mockVerifyLicenseUseCase;

  late Widget authPage;
  late AuthBloc authBloc;

  setUpAll(() async {
    mockLoginWithCnpjAndNameAndPasswordUsecase =
        MockLoginWithCnpjAndNameAndPasswordUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockVerifyLicenseUseCase = MockVerifyLicenseUseCase();

    authBloc = AuthBloc(
      loginWithCnpjAndNameAndPasswordUsecase:
          mockLoginWithCnpjAndNameAndPasswordUsecase,
      logoutUsecase: mockLogoutUsecase,
      verifyLicenseUseCase: mockVerifyLicenseUseCase,
    );

    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }

    getIt.registerFactory<AuthBloc>(() => authBloc);

    authPage = const MaterialApp(
      home: Scaffold(
        body: AuthPage(),
      ),
    );

    Mocks().initializeFakeAppGlobal();
    clearInteractions(mockLoginWithCnpjAndNameAndPasswordUsecase);
    clearInteractions(mockLogoutUsecase);
    clearInteractions(mockVerifyLicenseUseCase);
  });

  testWidgets('should render a auth screen', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(authPage);
      await tester.pumpAndSettle();

      final Finder inputsFinder = find.byType(TextFormField);
      final Finder buttonLoginFinder = find.byType(ElevatedButton);
      final Finder cnpjTextFinder = find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.data == 'CNPJ');
      final Finder textEnterButtonFinder = find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.data == 'Entrar');

      expect(inputsFinder, findsNWidgets(1));
      expect(cnpjTextFinder, findsOneWidget);
      expect(textEnterButtonFinder, findsOneWidget);
      expect(buttonLoginFinder, findsOneWidget);
    });
  });

  testWidgets('should call loginWithCnpjAndNameAndPasswordUsecase',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(authPage);
      await tester.pumpAndSettle();

      final Finder cnpjInputFinder = find.byType(TextFormField);
      final Finder buttonLoginFinder = find.byType(ElevatedButton);

      await tester.enterText(cnpjInputFinder, '12345678901234');
      await tester.tap(buttonLoginFinder);
      await tester.pumpAndSettle();

      verify(mockLoginWithCnpjAndNameAndPasswordUsecase(any)).called(1);
    });
  });
}
