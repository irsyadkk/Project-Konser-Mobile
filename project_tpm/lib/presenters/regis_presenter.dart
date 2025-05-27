import 'package:project_tpm/networks/base_network.dart';

abstract class RegisView {
  void showLoading();
  void hideLoading();
  void onRegisSuccess();
  void showError(String msg);
}

class RegisPresenter {
  final RegisView view;
  RegisPresenter(this.view);

  Future<void> regisUser(String endpoint, Map<String, dynamic> data) async {
    view.showLoading();
    try {
      await BaseNetwork.regisUser(endpoint, data);
      view.onRegisSuccess();
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
