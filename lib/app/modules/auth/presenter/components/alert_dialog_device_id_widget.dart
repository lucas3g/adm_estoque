import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class AlertDialogDeviceIdWidget extends StatelessWidget {
  const AlertDialogDeviceIdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Código do dispositivo',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Text(
            '${AppGlobal.instance.device?.deviceId.value}',
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: 18,
            ),
          ),
          const SpacerHeight(),
          Text(
            'Se você já tem um licença, por favor, ignore esta mensagem.',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AppCustomButton(
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
