import 'package:adm_estoque/app/core/domain/entities/app_assets.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool userLoggedLicenseActiveHasIpServer() {
    final AppGlobal appGlobal = AppGlobal.instance;

    return appGlobal.user != null &&
        appGlobal.device!.active &&
        appGlobal.baseUrl.isNotEmpty;
  }

  Future<void> _init() async {
    BotToast.showWidget(
      toastBuilder: (_) => Material(
        color: Colors.transparent,
        child: SizedBox(
          width: context.screenWidth,
          height: context.screenHeight,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SpacerHeight(),
                Text(
                  'Verificando licença...',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpacerHeight(),
              ],
            ),
          ),
        ),
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    BotToast.cleanAll();

    if (userLoggedLicenseActiveHasIpServer()) {
      await Navigator.pushReplacementNamed(context, NamedRoutes.home.route);
    } else {
      if (AppGlobal.instance.baseUrl.isEmpty) {
        await Navigator.pushReplacementNamed(context, NamedRoutes.config.route);

        return;
      }

      await Navigator.pushReplacementNamed(context, NamedRoutes.login.route);
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async => _init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.admEstoque2,
          width: context.screenWidth * .8,
        ),
      ),
    );
  }
}
