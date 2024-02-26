import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/vos/value_object.dart';
import 'package:brasil_fields/brasil_fields.dart';

class CnpjVO extends ValueObject<String> {
  const CnpjVO(super.value);

  @override
  EitherOf<String, CnpjVO> validate([Object? object]) {
    if (value.isEmpty) {
      return reject('$object não pode ser vazio');
    }

    if (!UtilBrasilFields.isCNPJValido(value)) {
      return reject('$object Inválido');
    }

    return resolve(this);
  }
}
