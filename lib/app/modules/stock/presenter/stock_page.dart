import 'dart:async';

import 'package:adm_estoque/app/core/domain/entities/app_assets.dart';
import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/di/dependency_injection.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/modules/stock/presenter/components/card_product_widget.dart';
import 'package:adm_estoque/app/modules/stock/presenter/components/ccusto_dropdown_widget.dart';
import 'package:adm_estoque/app/modules/stock/presenter/components/modal_products_by_name_widget.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/product/product_bloc.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/product/product_events.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/product/product_states.dart';
import 'package:adm_estoque/app/shared/components/app_snackbar.dart';
import 'package:adm_estoque/app/shared/components/custom_app_bar.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/components/spacer_width.dart';
import 'package:adm_estoque/app/shared/components/text_form_field.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:adm_estoque/app/shared/utils/formatters.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final GlobalKey<FormState> _gkForm = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final FocusNode fId = FocusNode();
  final FocusNode fDesc = FocusNode();
  final FocusNode fQtd = FocusNode();

  final ProductBloc _productBloc = getIt<ProductBloc>();

  StreamSubscription<ProductStates>? _sub;

  bool typedId = false;
  bool typedName = false;
  bool typedQuantity = false;
  int popOneTime = 0;

  @override
  void initState() {
    super.initState();

    _sub = _productBloc.stream.listen((ProductStates state) async {
      if (state is ProductSuccessState) {
        FocusScope.of(context).unfocus();
        quantityController.clear();
      }

      if (state is ProductsByNameSuccessState) {
        await _showModalProducts(state.products);
      }

      if (state is UpsertStockSuccessState) {
        idController.clear();
        descController.clear();
        quantityController.clear();

        setState(() {
          typedId = false;
          typedQuantity = false;
        });

        if (mounted) {
          showAppSnackbar(
            context,
            title: 'Sucesso',
            message: 'Estoque atualizado!',
            type: TypeSnack.success,
            duration: 1,
          );
        }

        if (AppGlobal.instance.openCameraWhenUpsertStock) {
          await Future<void>.delayed(
            const Duration(seconds: 1),
          );

          await _startScannBarcode();
        }
      }

      if (state is ProductErrorState) {
        idController.clear();
        descController.clear();
        quantityController.clear();

        setState(() {
          typedId = false;
          typedName = false;
          typedQuantity = false;
        });

        if (state.message.contains('demonstração')) {
          showAppSnackbar(
            context,
            title: 'Atenção',
            message: state.message,
            type: TypeSnack.warning,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub!.cancel();
      _productBloc.close();
    }
    super.dispose();
  }

  Future<void> _showModalProducts(List<ProductEntity> products) async {
    FocusScope.of(context).unfocus();

    final ProductEntity? product = await showDialog<ProductEntity>(
      context: context,
      builder: (BuildContext context) => ModalProductsByNameWidget(
        products: products,
      ),
    );

    if (product != null) {
      FocusScope.of(context).unfocus();

      _productBloc.add(
        GetProductByIdEvent(
          id: product.id.value,
        ),
      );
    }
  }

  void _getProduct() {
    FocusScope.of(context).unfocus();

    if (typedId) {
      _productBloc.add(
        GetProductByIdEvent(
          id: idController.text,
        ),
      );
    }

    if (typedName) {
      _productBloc.add(
        GetProductsByNameEvent(
          name: descController.text,
        ),
      );
    }
  }

  void _upsertStock() {
    if (!_gkForm.currentState!.validate() && typedQuantity) {
      return;
    }

    final ProductEntity product =
        (_productBloc.state as ProductSuccessState).product;

    product.setNewQtd(
      product.newQtd.value + double.parse(quantityController.text),
    );

    _productBloc.add(
      UpsertStockEvent(
        product: product,
      ),
    );
  }

  Widget _makeIconButtonUpsertStock(ProductStates state) {
    if (state is ProductLoadingState) {
      return const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const Icon(Icons.check);
  }

  Future<void> _startScannBarcode() async {
    setState(() {
      descController.clear();
      typedName = false;
    });

    await Navigator.of(context).push(
      MaterialPageRoute<AiBarcodeScanner>(
        builder: (BuildContext context) => AiBarcodeScanner(
          bottomBarText: '',
          onScannerStarted: (MobileScannerArguments? v) {
            setState(() {
              popOneTime = 0;
              typedId = false;
            });
          },
          validator: (String value) {
            return value.isNotEmpty && value.length <= 13;
          },
          canPop: false,
          onScan: (String value) {
            setState(() {
              idController.text = value;
              typedId = value.trim().isNotEmpty;
            });

            if (Navigator.canPop(context) && popOneTime == 0) {
              setState(() {
                popOneTime++;
              });

              Navigator.pop(context);

              _getProduct();
            }
          },
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Conferir Estoque',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.background,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.padding),
        child: Form(
          key: _gkForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: <Widget>[
                    const CCustoDropDownWidget(),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: AppTextFormField(
                              focusNode: fId,
                              controller: idController,
                              title: 'Código',
                              hint: 'Digite o código da mercadoria',
                              borderColor: context.colorScheme.onBackground,
                              onChanged: (String value) {
                                setState(() {
                                  typedId = value.trim().isNotEmpty;
                                  descController.clear();
                                  typedName = false;
                                });
                              }),
                        ),
                        const SpacerWidth(),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                backgroundColor: context.colorScheme.primary,
                                textStyle:
                                    context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppThemeConstants.mediumBorderRadius,
                                  ),
                                ),
                              ),
                              onPressed: _startScannBarcode,
                              child: Lottie.asset(
                                AppAssets.barcodeJson,
                                repeat: false,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SpacerHeight(),
                    AppTextFormField(
                      focusNode: fDesc,
                      controller: descController,
                      title: 'Descrição',
                      hint: 'Digite a descrição do mercadoria',
                      borderColor: context.colorScheme.onBackground,
                      onChanged: (String value) {
                        setState(() {
                          typedName = value.trim().isNotEmpty;
                          idController.clear();
                          typedId = false;
                        });
                      },
                      inputFormatters: <TextInputFormatter>[
                        UpperCaseTextFormatter()
                      ],
                    ),
                    const SpacerHeight(),
                    AppCustomButton(
                      expands: true,
                      height: 45,
                      label: const Text('Buscar mercadoria'),
                      icon: const Icon(Icons.search),
                      onPressed: !typedId && !typedName ? null : _getProduct,
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    AppTextFormField(
                      focusNode: fQtd,
                      controller: quantityController,
                      title: 'Quantidade',
                      hint: 'Digite a quantidade',
                      borderColor: context.colorScheme.onBackground,
                      keyboardType: const TextInputType.numberWithOptions(),
                      onChanged: (String value) {
                        setState(() {
                          typedQuantity = value.trim().isNotEmpty;
                        });
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Informe a quantidade.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    BlocBuilder<ProductBloc, ProductStates>(
                        bloc: _productBloc,
                        builder: (BuildContext context, ProductStates states) {
                          if (states is ProductLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (states is ProductErrorState) {
                            final String message = states.message;

                            if (message
                                .contains('Mercadoria não encontrada!')) {
                              return Center(
                                child: Text(
                                  message,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                          }

                          if (states is ProductSuccessState) {
                            final ProductEntity product = states.product;

                            return CardProductWidget(product: product);
                          }

                          return const SizedBox();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: BlocBuilder<ProductBloc, ProductStates>(
              bloc: _productBloc,
              builder: (BuildContext context, ProductStates states) {
                return AppCustomButton(
                  expands: true,
                  height: 45,
                  icon: _makeIconButtonUpsertStock(states),
                  label: const Text('Atualizar estoque'),
                  onPressed: !typedQuantity ? null : _upsertStock,
                );
              }),
        ),
      ),
    );
  }
}
