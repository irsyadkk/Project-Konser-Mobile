class User {
  final int id;
  final String email;
  final int umur;
  final String nama;
  final String? accessToken;

  User({
    required this.id,
    required this.email,
    required this.umur,
    required this.nama,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json, String? token) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? "",
      umur: json['umur'] ?? "",
      nama: json['nama'] ?? "",
      accessToken: token,
    );
  }
}
