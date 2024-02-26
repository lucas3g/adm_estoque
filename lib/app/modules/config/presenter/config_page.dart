import 'package:adm_estoque/app/core/data/clients/local_storage/local_storage.dart';
import 'package:adm_estoque/app/core/data/clients/local_storage/params/shared_params.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/named_routes.dart';
import 'package:adm_estoque/app/core/domain/entities/storage_keys.dart';
import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/config/domain/usecases/change_ip_server_client_http.dart';
import 'package:adm_estoque/app/modules/config/presenter/components/title_config_widget.dart';
import 'package:adm_estoque/app/modules/stock/presenter/components/ccusto_dropdown_widget.dart';
import 'package:adm_estoque/app/shared/components/custom_app_bar.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/components/spacer_width.dart';
import 'package:adm_estoque/app/shared/components/text_form_field.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final LocalStorage _shared = getIt<LocalStorage>();
  final ChangeIpServerClientHttpUseCase _changeIpServerClientHttpUseCase =
      getIt<ChangeIpServerClientHttpUseCase>();

  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  bool hasIp = false;
  bool hasUser = AppGlobal.instance.user != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readIpServer();
    });
  }

  Future<void> _setOpenCameraLocalStorage() async {
    setState(() {
      AppGlobal.instance.setOpenCameraWhenUpsertStock(
        !AppGlobal.instance.openCameraWhenUpsertStock,
      );
    });

    final SharedParams<String> params = SharedParams<String>(
      key: StorageKeys.openCamera,
      value: AppGlobal.instance.openCameraWhenUpsertStock ? 'S' : 'N',
    );

    await _shared.setData(params: params);
  }

  Future<void> _setIpServer() async {
    final String ipServer =
        'http://${ipController.text}:${portController.text}';

    final SharedParams<String> params = SharedParams<String>(
      key: StorageKeys.ipServer,
      value: ipServer,
    );

    AppGlobal.instance.setBaseUrl(ipServer);

    if (await _shared.setData(params: params)) {
      if (AppGlobal.instance.user != null) {
        await _changeIpServerClientHttpUseCase(ipServer);

        Navigator.pop(context);

        return;
      }

      await Navigator.pushReplacementNamed(context, NamedRoutes.login.route);
    }
  }

  Future<void> _readIpServer() async {
    final String? ipServer = await _shared.getData(StorageKeys.ipServer);

    if (ipServer != null) {
      setState(() {
        hasIp = true;
      });

      final List<String> ip = ipServer.split(':');

      ipController.text = ip[1].replaceAll('//', '');
      portController.text = ip[2];
    } else {
      portController.text = '9000';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Configurações',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.background,
            fontSize: AppThemeConstants.mediumFontSize,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.padding),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const TitleConfigWidget(title: 'Configurações do Servidor'),
            const SpacerHeight(),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: AppTextFormField(
                    controller: ipController,
                    title: 'IP do Servidor',
                    hint: 'Digite o IP do servidor',
                    borderColor: context.colorScheme.onBackground,
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                ),
                const SpacerWidth(),
                Expanded(
                  child: AppTextFormField(
                    controller: portController,
                    title: 'Porta',
                    hint: 'Porta',
                    borderColor: context.colorScheme.onBackground,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SpacerHeight(),
            AppCustomButton(
              onPressed: _setIpServer,
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              expands: true,
            ),
            if (hasIp && hasUser)
              Column(
                children: <Widget>[
                  const SpacerHeight(),
                  const TitleConfigWidget(title: 'Tipo do Estoque'),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile<TypeStock>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          visualDensity: VisualDensity.compact,
                          title: const Text('Contábil'),
                          value: TypeStock.contabil,
                          groupValue: AppGlobal.instance.typeStock,
                          onChanged: (TypeStock? value) {
                            setState(() {
                              AppGlobal.instance.setTypeStock(value!);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TypeStock>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          visualDensity: VisualDensity.compact,
                          title: const Text('Fisico'),
                          value: TypeStock.fisico,
                          groupValue: AppGlobal.instance.typeStock,
                          onChanged: (TypeStock? value) {
                            setState(() {
                              AppGlobal.instance.setTypeStock(value!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SpacerHeight(),
                  const TitleConfigWidget(title: 'Centro de Custo - Padrão'),
                  const CCustoDropDownWidget(title: 'Padrão'),
                  const SpacerHeight(),
                  const TitleConfigWidget(title: 'Configuração do Aplicativo'),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: AppGlobal.instance.openCameraWhenUpsertStock,
                        onChanged: (bool? v) {
                          _setOpenCameraLocalStorage();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _setOpenCameraLocalStorage();
                        },
                        child: const Text('Abrir câmera ao atualizar estoque?'),
                      )
                    ],
                  ),
                ],
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}

enum TypeStock { contabil, fisico }
