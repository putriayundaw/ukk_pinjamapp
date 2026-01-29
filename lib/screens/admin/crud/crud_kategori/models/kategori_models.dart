class KategoriModel {
  final int kategoriId;
  final String namaKategori;
  final DateTime createdAt;
  final DateTime updatedAt;

  KategoriModel({
    required this.kategoriId,
    required this.namaKategori,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      kategoriId: json['kategori_id'],
      namaKategori: json['nama_kategori'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
