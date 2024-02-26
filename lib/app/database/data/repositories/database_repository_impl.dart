import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/database/data/datasources/database_datasource.dart';
import 'package:adm_estoque/app/database/domain/entities/database_failure.dart';
import 'package:adm_estoque/app/database/domain/repositories/database_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DatabaseRepository)
class DatabaseRepositoryImpl implements DatabaseRepository {
  final DatabaseDatasource _databaseDatasource;

  DatabaseRepositoryImpl({required DatabaseDatasource databaseDatasource})
      : _databaseDatasource = databaseDatasource;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> populateHive() async {
    try {
      final bool result = await _databaseDatasource.populateHive();

      if (result) {
        return resolve(const VoidSuccess());
      } else {
        return reject(DatabaseFailure(message: 'Error populating hive'));
      }
    } catch (e) {
      return reject(DatabaseFailure(message: 'Error populating hive'));
    }
  }
}
