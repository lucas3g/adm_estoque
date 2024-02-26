import '../../../domain/entities/user_entity.dart';

abstract class UserLocalDataSource {
  Future<UserEntity?> getUser();
  Future<void> logoutUser();
  Future<void> cacheUser(UserEntity user);
}
