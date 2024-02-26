import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/modules/home/presenter/components/card_menu_widget.dart';
import 'package:adm_estoque/app/shared/domain/entities/card_menu_button.dart';
import 'package:flutter/material.dart';

class ListCardMenuWidget extends StatelessWidget {
  const ListCardMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CardMenuWidget(
          title: 'Estoque',
          myButtons: <CardMenuButtonEntity>[
            CardMenuButtonEntity(
              label: 'Conferência',
              icon: const Icon(
                Icons.inventory_rounded,
                size: 40,
              ),
              route: NamedRoutes.stock.route,
            ),
          ],
        ),
        const SizedBox(height: 10),
        CardMenuWidget(
          title: 'Utilitários',
          myButtons: <CardMenuButtonEntity>[
            CardMenuButtonEntity(
              label: 'Configuração',
              icon: const Icon(Icons.settings_rounded, size: 40),
              route: NamedRoutes.config.route,
            ),
          ],
        ),
      ],
    );
  }
}
