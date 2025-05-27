import 'package:project_tpm/models/user_model.dart';
import 'package:project_tpm/networks/base_network.dart';

abstract class LoginView {
  void showLoading();
  void hideLoading();
  void onLoginSuccess(User user);
  void showError(String msg);
}

class LoginPresenter {
  final LoginView view;
  LoginPresenter(this.view);

  Future<void> loginUser(String endpoint, Map<String, dynamic> data) async {
    view.showLoading();
    try {
      final user = await BaseNetwork.loginUser(endpoint, data);
      view.onLoginSuccess(user);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
