import 'dart:async';

import 'package:adm_estoque/app/core/domain/entities/app_assets.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/app_mode.dart';
import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/auth/presenter/components/alert_dialog_demo_version_widget.dart';
import 'package:adm_estoque/app/modules/auth/presenter/components/alert_dialog_device_id_widget.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_bloc.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_events.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_states.dart';
import 'package:adm_estoque/app/modules/user/domain/adapters/user_adapter.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:adm_estoque/app/shared/components/app_snackbar.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/components/text_form_field.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:adm_estoque/app/shared/utils/formatters.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final GlobalKey<FormState> _gkForm = GlobalKey<FormState>();

  final FocusNode fCnpj = FocusNode();
  final FocusNode fUser = FocusNode();
  final FocusNode fPassword = FocusNode();

  late StreamSubscription<AuthStates> _sub;

  final UserEntity _user = UserAdapter.empty();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _sub = _authBloc.stream.listen((AuthStates state) async {
      if (state is LicenseNoData) {
        showAppSnackbar(
          context,
          title: 'Atenção',
          message:
              'Licença não encontrada. Por favor entre em contato com o suporte.',
          type: TypeSnack.warning,
        );
      }

      if (state is LicenseActive) {
        AppGlobal.instance.appMode.add(AppMode.production);

        _authBloc.add(
          AuthInitLoginEvent(
            user: _user,
          ),
        );
      }

      if (state is LicenseInactive) {
        showAppSnackbar(
          context,
          title: 'Atenção',
          message: 'Licença inátiva. Por favor entre em contato com o suporte.',
          type: TypeSnack.warning,
        );
      }

      if (state is LicenseError) {
        showAppSnackbar(
          context,
          title: 'Atenção',
          message: state.message,
          type: TypeSnack.error,
        );
      }

      if (state is AuthError) {
        showAppSnackbar(
          context,
          title: 'Atenção',
          message: state.message,
          type: TypeSnack.error,
        );
      }

      if (state is AuthSuccess) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          NamedRoutes.home.route,
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authBloc.close();
    _sub.cancel();

    super.dispose();
  }

  Widget _makeButtonLoginByStatesLogin(AuthStates state) {
    if (state is AuthLoading || state is LicenseActive) {
      return const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(),
      );
    }

    return Icon(
      Icons.login,
      color: context.colorScheme.primary,
    );
  }

  void validateFormAndInitLogin() {
    if (_gkForm.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      _authBloc.add(
        VerifyLicenseEvent(
          license: AppGlobal.instance.device!.deviceId.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: context.screenWidth,
            height: context.screenHeight,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: const Alignment(1, -0.9),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NamedRoutes.config.route);
                    },
                    icon: Icon(
                      Icons.settings_rounded,
                      color: context.colorScheme.onBackground,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.0, -0.7),
                  child: Image.asset(
                    AppAssets.admEstoque2,
                    width: context.screenWidth * .9,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppThemeConstants.padding),
              height: context.screenHeight * 0.62,
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _gkForm,
                    child: Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Acessar sua conta',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colorScheme.background,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SpacerHeight(),
                          AppTextFormField(
                            focusNode: fCnpj,
                            title: 'CNPJ',
                            hint: 'Digite seu CNPJ',
                            value: _user.cnpj.value,
                            onChanged: _user.setCnpj,
                            validator: (String? v) =>
                                _user.cnpj.validate('CNPJ').exceptionOrNull(),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              CnpjInputFormatter(),
                            ],
                            onFieldSubmitted: (String _) =>
                                fUser.requestFocus(),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerHeight(),
                          AppTextFormField(
                            focusNode: fUser,
                            title: 'Usuário',
                            hint: 'Digite seu usuário',
                            value: _user.username.value,
                            onChanged: _user.setUserName,
                            validator: (String? v) => _user.username
                                .validate('Usuário')
                                .exceptionOrNull(),
                            inputFormatters: <TextInputFormatter>[
                              UpperCaseTextFormatter(),
                            ],
                            onFieldSubmitted: (String _) =>
                                fPassword.requestFocus(),
                            textInputAction: TextInputAction.next,
                          ),
                          const SpacerHeight(),
                          AppTextFormField(
                            focusNode: fPassword,
                            title: 'Senha',
                            hint: 'Digite sua senha',
                            hideInput: true,
                            value: _user.password.value,
                            onChanged: _user.setPassword,
                            validator: (String? v) => _user.password
                                .validate('Senha')
                                .exceptionOrNull(),
                            inputFormatters: <TextInputFormatter>[
                              UpperCaseTextFormatter(),
                            ],
                            onFieldSubmitted: (String _) =>
                                validateFormAndInitLogin(),
                            textInputAction: TextInputAction.done,
                          ),
                          const SpacerHeight(),
                          BlocBuilder<AuthBloc, AuthStates>(
                              bloc: _authBloc,
                              builder:
                                  (BuildContext context, AuthStates state) {
                                return AppCustomButton(
                                  onPressed: validateFormAndInitLogin,
                                  icon: _makeButtonLoginByStatesLogin(state),
                                  label: Text(
                                    'Entrar',
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                  expands: true,
                                  height: 45,
                                  backgroundColor:
                                      context.colorScheme.background,
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        const AlertDialogDeviceIdWidget(),
                                  );
                                },
                                child: Text(
                                  'Licença para uso do aplicativo',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.background,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        const AlertDialogDemoVersionWidget(),
                                  );
                                },
                                child: Text(
                                  'Versão de demonstração',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.background,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'EL Sistemas LTDA - 2024 - Fone: (54) 3364-1588',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
