import 'package:adm_estoque/app/core/domain/entities/base_entity.dart';
import 'package:adm_estoque/app/core/domain/vos/int_vo.dart';
import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';
import 'package:adm_estoque/app/modules/user/domain/entities/vos/cnpj_vo.dart';

class UserEntity extends BaseEntity {
  CnpjVO _cnpj;
  TextVO _username;
  TextVO _password;
  IntVO _ccusto;

  CnpjVO get cnpj => _cnpj;
  void setCnpj(String value) => _cnpj = CnpjVO(value);

  TextVO get username => _username;
  void setUserName(String value) => _username = TextVO(value);

  TextVO get password => _password;
  void setPassword(String value) => _password = TextVO(value);

  IntVO get ccusto => _ccusto;
  void setCCusto(int value) => _ccusto = IntVO(value);

  UserEntity({
    super.id,
    String? cnpj,
    required String username,
    String? password,
    required int ccusto,
  })  : _cnpj = CnpjVO(cnpj ?? ''),
        _username = TextVO(username),
        _password = TextVO(password ?? ''),
        _ccusto = IntVO(ccusto);

  @override
  int get hashCode =>
      _cnpj.hashCode ^
      _username.hashCode ^
      _password.hashCode ^
      _ccusto.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          _cnpj == other._cnpj &&
          _username == other._username &&
          _password == other._password &&
          _ccusto == other._ccusto;
}
