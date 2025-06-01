import 'package:flutter/material.dart';
import 'package:project_tpm/models/konser_model.dart';
import 'package:project_tpm/presenters/detailkonser_presenter.dart';
import 'package:project_tpm/views/order.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> implements DetailKonserView {
  late DetailKonserPresenter presenter;
  bool _isLoading = false;
  String? _errorMsg;
  Konser? _detailData;

  @override
  void initState() {
    super.initState();
    presenter = DetailKonserPresenter(this);
    fetchDetail();
  }

  void fetchDetail() {
    presenter.loadDetailKonser('konser', widget.id);
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showDetailData(Konser detail) {
    setState(() {
      _detailData = detail;
    });
  }

  @override
  void showError(String msg) {
    setState(() {
      _errorMsg = msg;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color yellowAccent = const Color(0xfff7c846);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: yellowAccent,
        title: _isLoading
            ? const CircularProgressIndicator()
            : _errorMsg != null
                ? Text("Error: $_errorMsg")
                : Text(_detailData?.nama ?? "Detail Konser"),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: yellowAccent))
          : _errorMsg != null
              ? Center(
                  child: Text("Error: $_errorMsg",
                      style: const TextStyle(color: Colors.redAccent)),
                )
              : _detailData != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Image.network(
                              _detailData!.poster,
                              width: double.infinity,
                              height: 550,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoCard("Tanggal", _detailData!.tanggal),
                                const SizedBox(height: 12),
                                _infoCard("Lokasi", _detailData!.lokasi),
                                const SizedBox(height: 12),
                                _infoCard(
                                    "Bintang Tamu", _detailData!.bintangtamu),
                                const SizedBox(height: 24),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: yellowAccent,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 6,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderPage(
                                            id: _detailData!.id,
                                            endpoint: "tiket",
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Pesan Tiket",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text("No data available",
                          style: TextStyle(color: Colors.white))),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
