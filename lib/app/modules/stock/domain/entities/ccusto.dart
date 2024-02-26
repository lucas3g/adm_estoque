import 'package:adm_estoque/app/core/domain/vos/int_vo.dart';
import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';

class CCustoEntity {
  IntVO _ccusto;
  TextVO _descricao;

  IntVO get ccusto => _ccusto;
  void setCCusto(int value) => _ccusto = IntVO(value);

  TextVO get descricao => _descricao;
  void setDescricao(String value) => _descricao = TextVO(value);

  CCustoEntity({
    required int ccusto,
    required String descricao,
  })  : _ccusto = IntVO(ccusto),
        _descricao = TextVO(descricao);
}
