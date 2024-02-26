import 'package:adm_estoque/app/modules/home/presenter/components/alert_dialog_logout_widget.dart';
import 'package:adm_estoque/app/modules/home/presenter/components/list_card_menu_widget.dart';
import 'package:adm_estoque/app/shared/components/custom_app_bar.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'ADM Estoque',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.background,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                routeSettings: const RouteSettings(name: 'dialog-logout'),
                context: context,
                builder: (BuildContext context) =>
                    const AlertDialogLogoutWidget(),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          AppThemeConstants.padding,
        ),
        child: Column(
          children: <Widget>[
            const Expanded(child: ListCardMenuWidget()),
            const Divider(),
            Text(
              'EL Sistemas LTDA - 2024',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
