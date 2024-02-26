import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/shared/components/custom_button.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:adm_estoque/app/shared/utils/formatters.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ModalProductsByNameWidget extends StatefulWidget {
  final List<ProductEntity> products;

  const ModalProductsByNameWidget({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ModalProductsByNameWidget> createState() =>
      _ModalProductsByNameWidgetState();
}

class _ModalProductsByNameWidgetState extends State<ModalProductsByNameWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text(
          'Lista de Mercadorias',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, int index) {
            final ProductEntity product = widget.products[index];

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 50,
                child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl:
                        '${AppEndpoints.imageProduct.path}/${product.gtin.value}',
                    placeholder: (BuildContext context, String url) => SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                    errorWidget:
                        (BuildContext context, String url, Object error) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: context.colorScheme.primary,
                          ),
                        ],
                      );
                    }),
              ),
              title: Text(product.description.value),
              subtitle: product.newQtd.value > 0
                  ? Text(
                      'Contado hoje: ${product.newQtd.value.formatDecimal()}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context, widget.products[index]);
              },
            );
          },
        ),
        const Divider(),
        AppCustomButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
          label: const Text('Fechar'),
        ),
      ]),
    );
  }
}
