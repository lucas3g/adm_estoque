import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';

abstract class DatabaseRepository {
  Future<EitherOf<AppFailure, VoidSuccess>> populateHive();
}
