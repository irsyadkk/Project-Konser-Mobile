import 'package:project_tpm/models/tiket_model.dart';
import 'package:project_tpm/networks/base_network.dart';

abstract class TiketView {
  void showLoading();
  void hideLoading();
  void showTiketList(List<Tiket> tiketList);
  void showError(String msg);
}

class TiketPresenter {
  final TiketView view;
  TiketPresenter(this.view);

  Future<void> loadTiketData(String endpoint) async {
    view.showLoading();
    try {
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final tiketList = data.map((json) => Tiket.fromJson(json)).toList();
      view.showTiketList(tiketList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }

  Future<void> editTiketData(
      String endpoint, Map<String, dynamic> data, int id) async {
    view.showLoading();
    try {
      await BaseNetwork.edit(endpoint, data, id);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
