import 'package:adm_estoque/app/core/domain/vos/text_vo.dart';

abstract class BaseEntity {
  final TextVO? id;

  BaseEntity({
    this.id,
  });
}
