import 'package:project_tpm/models/konser_model.dart';
import 'package:project_tpm/networks/base_network.dart';

abstract class KonserView {
  void showloading();
  void hideloading();
  void showKonserList(List<Konser> konserList);
  void showError(String msg);
}

class KonserPresenter {
  final KonserView view;
  KonserPresenter(this.view);

  Future<void> loadKonserData(String endpoint) async {
    view.showloading();
    try {
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final konserList = data.map((json) => Konser.fromJson(json)).toList();
      view.showKonserList(konserList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideloading();
    }
  }
}
