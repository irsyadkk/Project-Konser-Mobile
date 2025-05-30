import 'package:flutter/material.dart';
import 'package:project_tpm/models/konser_model.dart';
import 'package:project_tpm/presenters/konser_presenter.dart';
import 'package:project_tpm/views/detail.dart';
import 'package:project_tpm/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? userName;

  @override
  void initState() {
    super.initState();
    _presenter = KonserPresenter(this);
    getUserName();
    fetchData();
  }

  void fetchData() {
    _presenter.loadKonserData('konser');
  }

  @override
  void hideLoading() {
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
  void showLoading() {
    setState(() {
      _isloading = true;
    });
  }

  Future<void> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? nama = prefs.getString('user_nama');
    setState(() {
      userName = nama;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color yellowAccent = const Color(0xfff7c846);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Halo, $userName !'),
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
                  ? Center(
                      child: CircularProgressIndicator(color: yellowAccent))
                  : _errorMsg != null
                      ? Center(
                          child: Text(
                            "Error: $_errorMsg",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _konserList.length,
                          itemBuilder: (context, index) {
                            final konser = _konserList[index];
                            return _movieCard(konser, context);
                          },
                        ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      String text, VoidCallback onPressed, bool isSelected) {
    final Color yellowAccent = const Color(0xfff7c846);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? yellowAccent : Colors.transparent,
        foregroundColor: isSelected ? Colors.black : yellowAccent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: yellowAccent, width: 2),
        ),
        elevation: isSelected ? 8 : 0,
        shadowColor:
            isSelected ? yellowAccent.withOpacity(0.6) : Colors.transparent,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _movieCard(Konser konser, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(konser.poster),
        title: Text(konser.nama,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle:
            Text(konser.tanggal, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.redAccent),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(id: konser.id)));
        },
      ),
    );
  }
}
