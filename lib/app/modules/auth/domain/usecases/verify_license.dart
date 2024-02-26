import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyLicenseUseCase
    implements UseCase<VoidSuccess, VerifyLicenseUseCaseArgs> {
  final AuthRepository _repository;

  VerifyLicenseUseCase({required AuthRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(
      VerifyLicenseUseCaseArgs args) async {
    return _repository.verifyLicense(license: args.license);
  }
}

class VerifyLicenseUseCaseArgs {
  final String license;

  VerifyLicenseUseCaseArgs({required this.license});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is VerifyLicenseUseCaseArgs && other.license == license;
  }

  @override
  int get hashCode => license.hashCode;
}
