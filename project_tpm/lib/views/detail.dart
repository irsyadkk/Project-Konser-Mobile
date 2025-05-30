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
    return Scaffold(
        appBar: AppBar(
          title: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMsg != null
                  ? Center(child: Text("Error $_errorMsg"))
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
            : _errorMsg != null
                ? Center(child: Text("Error $_errorMsg"))
                : _detailData != null
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.network(_detailData!.poster),
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
                                            "Lokasi",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(_detailData!.lokasi),
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
                                            "Bintang Tamu",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:
                                              Text(_detailData!.bintangtamu),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage(
                                              id: _detailData!.id,
                                              endpoint: "tiket")));
                                },
                                child: Text("Pesan Tiket"))
                          ],
                        ),
                      )
                    : Text("No data available..."));
  }
}
