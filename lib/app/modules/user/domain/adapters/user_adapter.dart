import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';
import 'package:brasil_fields/brasil_fields.dart';

class UserAdapter extends UserEntity {
  UserAdapter({
    super.cnpj,
    required super.username,
    super.password,
    required super.ccusto,
  });

  factory UserAdapter.fromJson(Map<String, dynamic> json) {
    return UserAdapter(
      cnpj: json['CNPJ'],
      username: json['NOME'],
      ccusto: json['CCUSTO'],
    );
  }

  static Map<String, dynamic> toJsonLogin({
    required UserEntity user,
  }) {
    return <String, dynamic>{
      'cnpj': UtilBrasilFields.removeCaracteres(user.cnpj.value),
      'usuario': user.username.value,
      'senha': user.password.value,
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'CNPJ': UtilBrasilFields.removeCaracteres(cnpj.value),
      'NOME': username.value,
      'CCUSTO': ccusto.value,
    };
  }

  factory UserAdapter.fromEntity(UserEntity user) {
    return UserAdapter(
      cnpj: UtilBrasilFields.removeCaracteres(user.cnpj.value),
      username: user.username.value,
      ccusto: user.ccusto.value,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      cnpj: UtilBrasilFields.removeCaracteres(cnpj.value),
      username: username.value,
      ccusto: ccusto.value,
    );
  }

  static UserEntity empty() {
    return UserEntity(
      id: const TextVO(''),
      cnpj: '',
      username: '',
      ccusto: 0,
    );
  }
}
