import 'package:adm_estoque/app/core/domain/entities/failure.dart';

class ProductFailure extends AppFailure {
  ProductFailure({String? message}) : super(message ?? 'Produto Error');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ProductFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
