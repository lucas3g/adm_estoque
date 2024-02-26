import 'package:adm_estoque/app/modules/user/domain/entities/user_entity.dart';

class UserFixture {
  UserEntity userEntity() {
    return UserEntity(
      username: 'Lucas Silva',
      ccusto: 200,
      cnpj: '97305890000181',
    );
  }

  Map<String, dynamic> userJson() {
    return <String, dynamic>{
      'name': 'ADM',
      'paswword': 'EL',
      'ccusto': 200,
      'cnpj': '97305890000181',
    };
  }

  String userJsonString() {
    return '''{
      "name": "Lucas Silva",
      "ccusto": 200,
      "cnpj": "97305890000181"
    }''';
  }
}
