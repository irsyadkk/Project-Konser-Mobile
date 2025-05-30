class Konser {
  final int id;
  final String nama;
  final String poster;
  final String tanggal;
  final String lokasi;
  final String bintangtamu;

  Konser({
    required this.id,
    required this.nama,
    required this.poster,
    required this.tanggal,
    required this.lokasi,
    required this.bintangtamu,
  });

  factory Konser.fromJson(Map<String, dynamic> json) {
    return Konser(
        id: json['id'] ?? 0,
        nama: json['nama'] ?? "",
        poster: json['poster'] ?? "",
        tanggal: json['tanggal'] ?? "",
        lokasi: json['lokasi'] ?? "",
        bintangtamu: json['bintangtamu'] ?? "");
  }
}
