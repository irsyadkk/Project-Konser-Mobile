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
  Tiket? _detailData;
  String _selectedCur = 'IDR';

  final Map<String, double> _exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000061,
    'EUR': 0.000054,
    'SGD': 0.000079,
    'JPY': 0.008787,
    'MYR': 0.00026,
  };

  String _convertHarga(int harga) {
    double rate = _exchangeRates[_selectedCur] ?? 1;
    double converted = harga * rate;
    return _selectedCur == 'IDR'
        ? 'IDR ${harga.toString()}'
        : '$_selectedCur ${converted.toStringAsFixed(2)}';
  }

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
    setState(() {
      _namaController.text = prefs.getString('user_nama') ?? '';
      _umurController.text = prefs.getInt('user_umur')?.toString() ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
    });
  }

  void fetchdetail() {
    detailTiketPresenter.loadDetailTiket(widget.endpoint, widget.id);
  }

  void orderHandler() {
    int umur = int.tryParse(_umurController.text) ?? 0;

    if (umur < 17) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Maaf, umur minimal untuk memesan tiket adalah 17 tahun.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final data = {
      'nama': _namaController.text,
      'umur': _umurController.text,
      'email': _emailController.text,
    };
    orderPresenter.orderTiket('order', data, widget.id);
  }

  @override
  void hideLoading() {
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
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg == "Akun sudah pernah pesan" ? "Maaf, satu akun satu tiket" : msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  Widget buildInfoCard(String title, String value, {Color? color}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? const Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 255, 228, 131),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCardHarga(String title, String value, {Color? color}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? const Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 255, 228, 131),
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 150),
                DropdownButton<String>(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  value: _selectedCur,
                  items: _exchangeRates.keys.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCur = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _detailData?.nama ?? "Order Tiket",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detailData != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildInfoCard("Tanggal", _detailData!.tanggal),
                      buildInfoCardHarga(
                          "Harga", _convertHarga(_detailData!.harga)),
                      buildInfoCard("Quota", _detailData!.quota.toString()),
                      const SizedBox(height: 24),
                      _detailData!.quota <= 0
                          ? const Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Text(
                                "Maaf, kuota tiket habis.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ElevatedButton(
                              onPressed:
                                  _detailData!.quota > 0 ? orderHandler : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 196, 35),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Pesan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : const Center(child: Text("No data available...")),
    );
  }
}
