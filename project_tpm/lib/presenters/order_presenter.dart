import 'package:project_tpm/networks/base_network.dart';

abstract class OrderView {
  void onOrderSuccess();
  void showError(String msg);
}

class OrderPresenter {
  final OrderView view;
  OrderPresenter(this.view);

  Future<void> orderTiket(
      String endpoint, Map<String, dynamic> data, int id) async {
    try {
      await BaseNetwork.order(endpoint, data, id);
      view.onOrderSuccess();
    } catch (e) {
      view.showError(e.toString());
    }
  }
}
