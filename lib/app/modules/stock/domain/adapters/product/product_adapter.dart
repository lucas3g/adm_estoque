import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/product.dart';

class ProductAdapter extends ProductEntity {
  ProductAdapter({
    required super.id,
    required super.description,
    required super.gtin,
    required super.newQtd,
    required super.oldQtd,
    required super.typeStock,
  });

  static Map<String, dynamic> toJsonHeaderAPI(String value, String field) {
    return <String, dynamic>{
      'cnpj': AppGlobal.instance.user!.cnpj.value,
      'field': field,
      'value': value,
    };
  }

  static Map<String, dynamic> toJsonStockHeaderAPI(int ccusto) {
    return <String, dynamic>{
      'cnpj': AppGlobal.instance.user!.cnpj.value,
      'ccusto': ccusto,
    };
  }

  static ProductEntity fromJson(dynamic json) {
    return ProductEntity(
      id: json['ID'],
      description: json['DESCRICAO'],
      gtin: json['GTIN'],
      newQtd: double.tryParse(json['QTD_NOVO'].toString()) ?? 0.00,
      oldQtd: double.tryParse(json['QTD_ANTES'].toString()) ?? 0.00,
      typeStock:
          AppGlobal.instance.typeStock!.name.contains('Contabil') ? 'C' : 'F',
    );
  }

  static Map<String, dynamic> toJson(ProductEntity product) {
    return <String, dynamic>{
      'CCUSTO': AppGlobal.instance.user!.ccusto.value,
      'MERCADORIA': product.id.value,
      'DATA': DateTime.now().toIso8601String(),
      'QTD_NOVO': product.newQtd.value,
      'QTD_ANTES': product.oldQtd.value,
      'QTD_AJUSTADO': null,
      'AJUSTADO': 'N',
      'CONTABIL_FISICO':
          AppGlobal.instance.typeStock!.name.contains('contabil') ? 'C' : 'F',
    };
  }
}
