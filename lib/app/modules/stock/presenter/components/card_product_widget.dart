// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adm_estoque/app/core/domain/entities/app_endpoints.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';
import 'package:adm_estoque/app/shared/components/spacer_height_widget.dart';
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:adm_estoque/app/shared/utils/formatters.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardProductWidget extends StatefulWidget {
  final ProductEntity product;

  const CardProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<CardProductWidget> createState() => _CardProductWidgetState();
}

class _CardProductWidgetState extends State<CardProductWidget> {
  @override
  Widget build(BuildContext context) {
    final ProductEntity product = widget.product;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppThemeConstants.mediumBorderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorScheme.primary,
              width: 5,
            ),
            bottom: BorderSide(
              color: context.colorScheme.primary,
              width: 5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: context.screenWidth * .35,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${AppEndpoints.imageProduct.path}/${product.gtin.value}',
                    placeholder: (BuildContext context, String url) => SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (BuildContext context, String url, Object error) => const SizedBox(),
                  ),
                ),
              ),
              const SpacerHeight(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      product.description.value,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SpacerHeight(),
              Row(
                children: <Widget>[
                  Text(
                    'Estoque contado hoje: ',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(product.newQtd.value.formatDecimal())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
