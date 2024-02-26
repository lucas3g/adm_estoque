import 'dart:async';

import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_bloc.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_events.dart';
import 'package:adm_estoque/app/modules/auth/presenter/controller/auth_states.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertDialogLogoutWidget extends StatefulWidget {
  const AlertDialogLogoutWidget({super.key});

  @override
  State<AlertDialogLogoutWidget> createState() =>
      _AlertDialogLogoutWidgetState();
}

class _AlertDialogLogoutWidgetState extends State<AlertDialogLogoutWidget> {
  final AuthBloc _authBloc = getIt<AuthBloc>();

  StreamSubscription<AuthStates>? _sub;

  Widget _makeButtonLogout(AuthStates state) {
    if (state is LogoutLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: context.colorScheme.background,
        ),
      );
    }

    return const Icon(Icons.done);
  }

  @override
  void initState() {
    super.initState();

    _sub = _authBloc.stream.listen((AuthStates state) {
      if (state is LogoutSuccess) {
        Navigator.pushReplacementNamed(context, NamedRoutes.login.route);
      }
    });
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub?.cancel();
      _authBloc.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Deseja realmente sair?',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              AppCustomButton(
                backgroundColor: context.colorScheme.onBackground,
                onPressed: () {
                  Navigator.of(context).pop('dialog-logout');
                },
                icon: const Icon(Icons.close),
                label: const Text('Não'),
              ),
              BlocBuilder<AuthBloc, AuthStates>(
                  bloc: _authBloc,
                  builder: (BuildContext context, AuthStates state) {
                    return AppCustomButton(
                      onPressed: () {
                        _authBloc.add(LogoutEvent());
                      },
                      icon: _makeButtonLogout(state),
                      label: const Text('Sim'),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
