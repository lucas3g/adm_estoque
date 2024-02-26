import 'params/shared_params.dart';

abstract class LocalStorage {
  Future<bool> setData<T>({required SharedParams<T> params});
  Future<T?> getData<T>(String key);
  Future<bool> removeData(String key);
}
