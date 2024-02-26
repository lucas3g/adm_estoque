import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/core/routes/app_routes.dart';
import 'package:adm_estoque/app/core/routes/domain/entities/custom_transition.dart';
import 'package:adm_estoque/app/core/routes/domain/entities/custom_transition_type.dart';
import 'package:adm_estoque/app/core/routes/observer/routes_observer.dart';
import 'package:adm_estoque/app/shared/theme/themes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confere Estoque',
      builder: BotToastInit(),
      navigatorObservers: <NavigatorObserver>[
        RoutesObserver(),
        BotToastNavigatorObserver()
      ],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: NamedRoutes.splash.route,
      onGenerateRoute: CustomNavigator(
        generateAnimation: _generateAnimation,
      ).onGenerateRoute,
    );
  }

  CustomTransition _generateAnimation(RouteSettings settings) {
    if (settings.name == NamedRoutes.home.route) {
      return CustomTransition(
        transitionType: CustomTransitionType.fade,
        duration: const Duration(milliseconds: 400),
      );
    }

    if (settings.name == NamedRoutes.login.route) {
      return CustomTransition(
        transitionType: CustomTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      );
    }

    return CustomTransition(
      transitionType: CustomTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }
}
