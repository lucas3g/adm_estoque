// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/ccusto/ccusto_bloc.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/ccusto/ccusto_events.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/ccusto/ccusto_states.dart';
import 'package:adm_estoque/app/shared/components/app_snackbar.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CCustoDropDownWidget extends StatefulWidget {
  final String title;
  const CCustoDropDownWidget({
    Key? key,
    this.title = 'Centro de Custo',
  }) : super(key: key);

  @override
  State<CCustoDropDownWidget> createState() => _CCustoDropDownWidgetState();
}

class _CCustoDropDownWidgetState extends State<CCustoDropDownWidget> {
  final CCustoBloc _ccustoBloc = getIt<CCustoBloc>();

  StreamSubscription<CCustoStates>? _sub;

  @override
  void initState() {
    super.initState();

    _ccustoBloc.add(GetCCustosEvent());

    _sub = _ccustoBloc.stream.listen((CCustoStates state) {
      if (state is CCustoErrorState) {
        showAppSnackbar(
          context,
          title: 'Ops...',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub!.cancel();
      _ccustoBloc.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!widget.title.contains('Padrão'))
          Text(
            widget.title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        else
          const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.background,
              borderRadius: BorderRadius.circular(
                AppThemeConstants.mediumBorderRadius,
              ),
              border: Border.all(),
            ),
            child: BlocBuilder<CCustoBloc, CCustoStates>(
              bloc: _ccustoBloc,
              builder: (BuildContext context, CCustoStates states) {
                if (states is! CCustoSuccessState) {
                  return const Padding(
                    padding: EdgeInsets.all(
                      AppThemeConstants.padding,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final List<CCustoEntity> ccustos = states.ccustos;
                final int selectedCCusto = states.selectedCCusto;

                if (ccustos.isEmpty) {
                  return const Center(
                    child: Text('Nenhum centro de custo encontrado'),
                  );
                }

                return DropdownButton(
                  value: selectedCCusto,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppThemeConstants.padding,
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: context.colorScheme.primary,
                    size: 30,
                  ),
                  items: ccustos
                      .map(
                        (CCustoEntity ccusto) => DropdownMenuItem(
                          value: ccusto.ccusto.value,
                          child: Text(ccusto.descricao.value),
                        ),
                      )
                      .toList(),
                  onChanged: (int? value) {
                    _ccustoBloc.add(
                      SelectCCustoEvent(ccusto: value as int),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
