abstract class CCustoEvents {}

class GetCCustosEvent extends CCustoEvents {}

class SelectCCustoEvent extends CCustoEvents {
  final int ccusto;

  SelectCCustoEvent({required this.ccusto});
}
