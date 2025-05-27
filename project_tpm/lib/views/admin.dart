import 'package:flutter/material.dart';
import 'package:project_tpm/models/pengunjung_model.dart';
import 'package:project_tpm/presenters/pengunjung_presenter.dart';
import 'package:project_tpm/views/login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> implements PengunjungView {
  late PengunjungPresenter _presenterPengunjung;
  bool _isLoading = false;
  String? _errormsg;
  List<Pengunjung> _pengunjungList = [];
  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _bintangtamuController = TextEditingController();
  final _hargaController = TextEditingController();
  final _quotaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenterPengunjung = PengunjungPresenter(this);
    fetchPengunjung();
  }

  @override
  void hideloading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showError(String msg) {
    setState(() {
      _errormsg = msg;
    });
  }

  @override
  void showPengunjungList(List<Pengunjung> pengunjungList) {
    _pengunjungList = pengunjungList;
  }

  @override
  void showloading() {
    setState(() {
      _isLoading = true;
    });
  }

  void fetchPengunjung() {
    _presenterPengunjung.loadPengunjungData('pengunjung');
  }

  void _addMovie() {
    final nama = _namaController.text.trim();
    final tanggal = _tanggalController.text.trim();
    final lokasi = _lokasiController.text.trim();
    final bintangtamu = _bintangtamuController.text.trim();
    final harga = _hargaController.text.trim();
    final quota = _quotaController.text.trim();

    if (nama.isNotEmpty &&
        tanggal.isNotEmpty &&
        lokasi.isNotEmpty &&
        bintangtamu.isNotEmpty &&
        harga.isNotEmpty &&
        quota.isNotEmpty) {
      setState(() {
        //_movies.add({'title': title, 'genre': genre});
        _namaController.clear();
        _tanggalController.clear();
        _lokasiController.clear();
        _bintangtamuController.clear();
        _hargaController.clear();
        _quotaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color goldYellow = const Color(0xfff7c846);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.black,
        foregroundColor: goldYellow,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: goldYellow),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _errormsg != null
                  ? Center(child: Text("Error $_errormsg"))
                  : Text(_pengunjungList.length.toString()),
              Text('Tambah Konser Baru',
                  style: TextStyle(
                      color: goldYellow,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _namaController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tanggalController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lokasiController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              ElevatedButton(
                onPressed: _addMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldYellow,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text('Tambah Film'),
              ),
              // const SizedBox(height: 24),
              // const SizedBox(height: 8),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: _pengunjungList.length,
              //   itemBuilder: (context, index) {
              //     final pengunjung = _pengunjungList[index];
              //     return Card(
              //       color: Colors.white10,
              //       child: ListTile(
              //         title: Text(pengunjung['title']!,
              //             style: const TextStyle(color: Colors.white)),
              //         subtitle: Text(pengunjung['genre']!,
              //             style: const TextStyle(color: Colors.white70)),
              //       ),
              //     );
              //   },
              // ),
              const SizedBox(height: 24),
              Text('Data Pengunjung:',
                  style: TextStyle(
                      color: goldYellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pengunjungList.length,
                itemBuilder: (context, index) {
                  final pengunjung = _pengunjungList[index];
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(pengunjung.nama,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(pengunjung.tiket,
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
