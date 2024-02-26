import 'package:adm_estoque/app/core/domain/vos/double_vo.dart';
import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';

class ProductEntity {
  TextVO _id;
  TextVO _description;
  TextVO _gtin;
  DoubleVO _newQtd;
  DoubleVO _oldQtd;
  TextVO _typeStock;

  TextVO get id => _id;
  void setId(String value) => _id = TextVO(value);

  TextVO get description => _description;
  void setDescription(String value) => _description = TextVO(value);

  TextVO get gtin => _gtin;
  void setGtin(String value) => _gtin = TextVO(value);

  DoubleVO get newQtd => _newQtd;
  void setNewQtd(double value) => _newQtd = DoubleVO(value);

  DoubleVO get oldQtd => _oldQtd;
  void setOldQtd(double value) => _oldQtd = DoubleVO(value);

  TextVO get typeStock => _typeStock;
  void setTypeStock(String value) => _typeStock = TextVO(value);

  ProductEntity({
    required String id,
    required String description,
    required String gtin,
    required double newQtd,
    required double oldQtd,
    required String typeStock,
  })  : _id = TextVO(id),
        _description = TextVO(description),
        _gtin = TextVO(gtin),
        _newQtd = DoubleVO(newQtd),
        _oldQtd = DoubleVO(oldQtd),
        _typeStock = TextVO(typeStock);
}
