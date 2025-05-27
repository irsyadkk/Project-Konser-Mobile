import 'package:flutter/material.dart';
import 'package:project_tpm/models/konser_model.dart';
import 'package:project_tpm/presenters/konser_presenter.dart';
import 'package:project_tpm/views/detail.dart';
import 'package:project_tpm/views/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements KonserView {
  late KonserPresenter _presenter;
  bool _isloading = true;
  List<Konser> _konserList = [];
  String? _errorMsg;
  String _currentEndpoint = 'konser';

  @override
  void initState() {
    super.initState();
    _presenter = KonserPresenter(this);
    _presenter.loadKonserData(_currentEndpoint);
  }

  void fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadKonserData(endpoint);
    });
  }

  @override
  void hideloading() {
    setState(() {
      _isloading = false;
    });
  }

  @override
  void showError(String msg) {
    setState(() {
      _errorMsg = msg;
    });
  }

  @override
  void showKonserList(List<Konser> konserList) {
    setState(() {
      _konserList = konserList;
    });
  }

  @override
  void showloading() {
    setState(() {
      _isloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color yellowAccent = const Color(0xfff7c846);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_currentEndpoint),
        backgroundColor: Colors.black,
        foregroundColor: yellowAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: yellowAccent),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: _isloading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMsg != null
                        ? Center(child: Text("Error $_errorMsg"))
                        : ListView.builder(
                            itemCount: _konserList.length,
                            itemBuilder: (context, index) {
                              final konser = _konserList[index];
                              return _movieCard(konser, context);
                            })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => fetchData('konser'),
                    child: Text("Konser")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () => fetchData('tiket'), child: Text("Tiket")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () => fetchData('pengunjung'),
                    child: Text("Pengunjung")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _movieCard(Konser konser, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(konser.nama,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle:
            Text(konser.tanggal, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(id: konser.id, endpoint: _currentEndpoint)));
        },
      ),
    );
  }
}
