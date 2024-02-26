import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';

class CCustoAdapter extends CCustoEntity {
  CCustoAdapter({required super.ccusto, required super.descricao});

  static CCustoEntity fromJson(dynamic json) {
    return CCustoEntity(
      ccusto: json['ID'],
      descricao: json['DESCRICAO'],
    );
  }
}
