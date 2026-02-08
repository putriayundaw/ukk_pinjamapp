class Kategori {
  final int kategoriId;
  final String namaKategori;

  Kategori({required this.kategoriId, required this.namaKategori});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      kategoriId: json['kategori_id'],
      namaKategori: json['nama_kategori'],
    );
  }
}
