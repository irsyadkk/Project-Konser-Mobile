import 'package:flutter/material.dart';
import 'package:project_tpm/models/tiket_model.dart';
import 'package:project_tpm/presenters/detailtiket_presenter.dart';
import 'package:project_tpm/presenters/order_presenter.dart';
import 'package:project_tpm/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  final int id;
  final String endpoint;
  const OrderPage({super.key, required this.id, required this.endpoint});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    implements OrderView, DetailTiketView {
  late OrderPresenter orderPresenter;
  late DetailTiketPresenter detailTiketPresenter;
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  bool _isLoading = false;
  String? _errormsg;
  Tiket? _detailData;

  @override
  void initState() {
    super.initState();
    orderPresenter = OrderPresenter(this);
    detailTiketPresenter = DetailTiketPresenter(this);
    getUserData();
    fetchdetail();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? nama = prefs.getString('user_nama');
    int? umur = prefs.getInt('user_umur');
    String? email = prefs.getString('user_email');

    setState(() {
      _namaController.text = nama ?? '';
      _umurController.text = umur.toString();
      _emailController.text = email ?? '';
    });
  }

  void fetchdetail() {
    detailTiketPresenter.loadDetailTiket(widget.endpoint, widget.id);
  }

  void orderHandler() {
    final data = {
      'nama': _namaController.text,
      'umur': _umurController.text,
      'email': _emailController.text,
    };
    orderPresenter.orderTiket('order', data, widget.id);
  }

  @override
  void hideloading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onOrderSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void showDetailData(Tiket detail) {
    setState(() {
      _detailData = detail;
    });
  }

  @override
  void showError(String msg) {
    setState(() {
      _errormsg = msg;
    });
  }

  @override
  void showloading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errormsg != null
                  ? Center(child: Text("Error $_errormsg"))
                  : _detailData != null
                      ? Text(
                          _detailData?.nama ?? "???",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text("Failed to get Name..."),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errormsg != null
                ? Center(child: Text("Error $_errormsg"))
                : _detailData != null
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Tanggal",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(_detailData!.tanggal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Harga Tiket Masuk",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                              _detailData!.harga.toString()),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Quota Tersisa",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                              _detailData!.quota.toString()),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text("${widget.endpoint} / ${widget.id}"),
                            // Nama
                            TextField(
                              controller: _namaController,
                              style: const TextStyle(color: Colors.white),
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Nama',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Umur
                            TextField(
                              controller: _umurController,
                              style: const TextStyle(color: Colors.white),
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Umur',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),

                            // EMAIL
                            TextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: orderHandler,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xfff7c846),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Order',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
                    : Text("No data available..."));
  }
}
