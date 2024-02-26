import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';

sealed class CCustoStates {
  final List<CCustoEntity> ccustos;
  int selectedCCusto;

  CCustoStates({required this.ccustos, required this.selectedCCusto});

  CCustoInitialState initial() => CCustoInitialState();

  CCustoLoadingState loading() => CCustoLoadingState(
        ccustos: ccustos,
        selectedCCusto: selectedCCusto,
      );

  CCustoErrorState error({required String message}) => CCustoErrorState(
        ccustos: ccustos,
        message: message,
        selectedCCusto: selectedCCusto,
      );

  CCustoSuccessState success({
    required List<CCustoEntity> ccustos,
    required int selectedCCusto,
  }) =>
      CCustoSuccessState(
        ccustos: ccustos,
        selectedCCusto: selectedCCusto,
      );
}

class CCustoInitialState extends CCustoStates {
  CCustoInitialState() : super(ccustos: <CCustoEntity>[], selectedCCusto: 0);
}

class CCustoLoadingState extends CCustoStates {
  CCustoLoadingState({required super.ccustos, required super.selectedCCusto});
}

class CCustoErrorState extends CCustoStates {
  final String message;

  CCustoErrorState(
      {required super.ccustos,
      required this.message,
      required super.selectedCCusto});
}

class CCustoSuccessState extends CCustoStates {
  CCustoSuccessState({required super.ccustos, required super.selectedCCusto});
}
