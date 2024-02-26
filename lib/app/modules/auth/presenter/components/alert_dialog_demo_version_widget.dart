import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/app_mode.dart';
import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class AlertDialogDemoVersionWidget extends StatelessWidget {
  const AlertDialogDemoVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Iniciar versão de demonstração?',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Esta versão é apenas para demonstração os dados são fictícios e não podem ser alterados.',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SpacerHeight(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppCustomButton(
                expands: true,
                onPressed: () {
                  AppGlobal.instance.appMode.add(AppMode.demo);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    NamedRoutes.home.route,
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Iniciar'),
              ),
              AppCustomButton(
                expands: true,
                backgroundColor: context.colorScheme.onBackground,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Fechar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
