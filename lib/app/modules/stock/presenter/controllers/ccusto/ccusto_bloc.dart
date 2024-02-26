import 'package:adm_estoque/app/core/domain/entities/app_global.dart';
import 'package:adm_estoque/app/core/domain/entities/either_of.dart';
import 'package:adm_estoque/app/core/domain/entities/failure.dart';
import 'package:adm_estoque/app/core/domain/entities/usecase.dart';
import 'package:adm_estoque/app/modules/stock/domain/entities/ccusto.dart';
import 'package:adm_estoque/app/modules/stock/domain/usecases/get_all_ccustos.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/ccusto/ccusto_events.dart';
import 'package:adm_estoque/app/modules/stock/presenter/controllers/ccusto/ccusto_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CCustoBloc extends Bloc<CCustoEvents, CCustoStates> {
  final GetAllCustosUseCase _getAllCustosUseCase;

  CCustoBloc({
    required GetAllCustosUseCase getAllCustosUseCase,
  })  : _getAllCustosUseCase = getAllCustosUseCase,
        super(CCustoInitialState()) {
    on<GetCCustosEvent>(_getAllCCustos);
    on<SelectCCustoEvent>(_changeSelectedCCusto);
  }

  Future<void> _getAllCCustos(
      GetCCustosEvent event, Emitter<CCustoStates> emit) async {
    emit(state.loading());

    final EitherOf<AppFailure, List<CCustoEntity>> result =
        await _getAllCustosUseCase(const NoArgs());

    int ccustoUser = 0;

    if (AppGlobal.instance.user != null) {
      ccustoUser = AppGlobal.instance.user!.ccusto.value;
    }

    result.get(
      (AppFailure failure) => emit(state.error(message: failure.message)),
      (List<CCustoEntity> ccustos) => emit(
        state.success(
          ccustos: ccustos,
          selectedCCusto:
              ccustoUser > 0 ? ccustoUser : ccustos.first.ccusto.value,
        ),
      ),
    );
  }

  void _changeSelectedCCusto(
      SelectCCustoEvent event, Emitter<CCustoStates> emit) {
    AppGlobal.instance.user!.setCCusto(event.ccusto);

    emit(
      state.success(
        ccustos: state.ccustos,
        selectedCCusto: event.ccusto,
      ),
    );
  }
}
