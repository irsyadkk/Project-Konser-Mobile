import 'package:project_tpm/models/pengunjung_model.dart';
import 'package:project_tpm/networks/base_network.dart';

abstract class PengunjungView {
  void showloading();
  void hideloading();
  void showPengunjungList(List<Pengunjung> pengunjungList);
  void showError(String msg);
}

class PengunjungPresenter {
  final PengunjungView view;
  PengunjungPresenter(this.view);

  Future<void> loadPengunjungData(String endpoint) async {
    try {
      view.showloading();
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final pengunjungList =
          data.map((json) => Pengunjung.fromJson(json)).toList();
      view.showPengunjungList(pengunjungList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideloading();
    }
  }
}
