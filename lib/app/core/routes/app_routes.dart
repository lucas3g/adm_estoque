import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/core/routes/domain/entities/custom_transition.dart';
import 'package:adm_estoque/app/core/routes/presenter/custom_page_builder.dart';
import 'package:adm_estoque/app/modules/auth/presenter/auth_page.dart';
import 'package:adm_estoque/app/modules/config/presenter/config_page.dart';
import 'package:adm_estoque/app/modules/home/presenter/home_page.dart';
import 'package:adm_estoque/app/modules/splash/presenter/splash_page.dart';
import 'package:adm_estoque/app/modules/stock/presenter/stock_page.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  CustomNavigator({required this.generateAnimation});

  final CustomTransition Function(RouteSettings) generateAnimation;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Map<String, WidgetBuilder> appRoutes = <String, WidgetBuilder>{
      NamedRoutes.splash.route: (BuildContext context) => const SplashPage(),
      NamedRoutes.config.route: (BuildContext context) => const ConfigPage(),
      NamedRoutes.login.route: (BuildContext context) => const AuthPage(),
      NamedRoutes.home.route: (BuildContext context) => const HomePage(),
      NamedRoutes.stock.route: (BuildContext context) => const StockPage(),
    };

    final WidgetBuilder? builder = appRoutes[settings.name];

    if (builder != null) {
      final CustomTransition customTransition = generateAnimation(settings);

      return CustomPageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return builder(context);
        },
        customTransition: customTransition,
        settings: settings,
      );
    }

    return null;
  }
}
