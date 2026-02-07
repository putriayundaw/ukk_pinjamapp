class AlatModel {
  final int? alatId;
  final String namaAlat;
  final int kategoriId;
  final int stok;
  final String status;
  final String? imageUrl;

  AlatModel({
    this.alatId,
    required this.namaAlat,
    required this.kategoriId,
    required this.stok,
    required this.status,
    this.imageUrl,
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      alatId: json['alat_id'],
      namaAlat: json['nama_alat'],
      kategoriId: json['kategori_id'],
      stok: json['stok'],
      status: json['status'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_alat': namaAlat,
      'kategori_id': kategoriId,
      'stok': stok,
      'status': status,
      'image_url': imageUrl,
    };
  }
}
