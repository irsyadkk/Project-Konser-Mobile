class Tiket {
  final int id;
  final String nama;
  final String tanggal;
  final int harga;
  final int quota;

  Tiket({
    required this.id,
    required this.nama,
    required this.tanggal,
    required this.harga,
    required this.quota,
  });

  factory Tiket.fromJson(Map<String, dynamic> json) {
    return Tiket(
        id: json['id'] ?? 0,
        nama: json['nama'] ?? "",
        tanggal: json['tanggal'] ?? "",
        harga: json['harga'] ?? "",
        quota: json['quota'] ?? "");
  }
}
