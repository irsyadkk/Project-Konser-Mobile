// Tambahan import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_tpm/models/pengunjung_model.dart';
import 'package:project_tpm/models/profile_photo.dart';
import 'package:project_tpm/models/user_model.dart';
import 'package:project_tpm/presenters/detailpengunjung_presenter.dart';
import 'package:project_tpm/presenters/detailuser_presenter.dart';
import 'package:project_tpm/presenters/user_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    implements DetailUserView, UserView, DetailPengunjungView {
  late DetailUserPresenter _detailUserPresenter;
  late UserPresenter _userPresenter;
  late DetailPengunjungPresenter _detailPengunjungPresenter;
  bool _isLoading = false;
  String? _errorMsg;
  User? _detailUser;
  List<Pengunjung> _pengunjungList = [];
  String? localPhotoPath;

  @override
  void initState() {
    super.initState();
    _detailUserPresenter = DetailUserPresenter(this);
    _userPresenter = UserPresenter(this);
    _detailPengunjungPresenter = DetailPengunjungPresenter(this);
    fetchUserDetail();
    fetchUserTiket();
    loadLocalPhoto();
  }

  Future<void> savePhoto(String email, String photoPath) async {
    final box = Hive.box<ProfilePhoto>('profile_photos');
    final profilePhoto = ProfilePhoto(email: email, photoPath: photoPath);
    await box.put(email, profilePhoto);
  }

  Future<void> deletePhoto(String email) async {
    final box = Hive.box<ProfilePhoto>('profile_photos');
    await box.delete(email);
    setState(() {
      localPhotoPath = null;
    });
  }

  Future<void> loadLocalPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      final box = Hive.box<ProfilePhoto>('profile_photos');
      final photo = box.get(email);
      setState(() {
        localPhotoPath = photo?.photoPath;
      });
    }
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showError(String msg) {
    _errorMsg = msg;
  }

  @override
  void showLoading() {
    _isLoading = true;
  }

  @override
  void showDetailData(User detail) {
    setState(() {
      _detailUser = detail;
    });
  }

  @override
  void showDataPengunjungByEmail(List<Pengunjung> pengunjungList) {
    setState(() {
      _pengunjungList = pengunjungList;
    });
  }

  void fetchUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      _detailUserPresenter.loadDetailUser('users', email);
    }
  }

  void fetchUserTiket() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      _detailPengunjungPresenter.loadDetailPengunjung('pengunjung', email);
    }
  }

  @override
  void showUserList(List<User> userList) {}

  Future<void> openCamera() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null && email != null) {
      await savePhoto(email, pickedFile.path);
      await loadLocalPhoto();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: const Text("Foto berhasil ditambahkan"),
        ),
      );
    }
  }

  Future<void> showCameraOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Ambil Foto",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                await openCamera();
              },
            ),
            if (localPhotoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: const Text("Hapus Foto",
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  if (email != null) {
                    await deletePhoto(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: const Text("Foto berhasil dihapus"),
                      ),
                    );
                  }
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color yellowAccent = const Color(0xfff7c846);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.black,
        foregroundColor: yellowAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.grey,
                    backgroundImage: localPhotoPath != null
                        ? FileImage(File(localPhotoPath!))
                        : null,
                    child: localPhotoPath == null
                        ? const Icon(Icons.person,
                            size: 90, color: Colors.black)
                        : null,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: InkWell(
                      onTap: showCameraOptions,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _detailUser?.nama ?? '',
              style: TextStyle(
                  fontSize: 24,
                  color: yellowAccent,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              _detailUser?.email ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tiket yang kamu miliki:",
                style: TextStyle(
                  color: yellowAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _pengunjungList.isEmpty
                ? const Text(
                    "Belum ada tiket",
                    style: TextStyle(color: Colors.white70),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pengunjungList.length,
                    itemBuilder: (context, index) {
                      final tiket = _pengunjungList[index].tiket;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.confirmation_num,
                                  color: Colors.white70),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  tiket,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
