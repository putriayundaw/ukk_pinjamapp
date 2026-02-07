class KategoriModel {
  final int kategoriId;
  final String namaKategori;

  KategoriModel({
    required this.kategoriId,
    required this.namaKategori,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      kategoriId: json['kategori_id'],
      namaKategori: json['nama_kategori'],
    );
  }
}
