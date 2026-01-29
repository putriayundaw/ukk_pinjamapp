// lib/screens/admin/crud/crud_alat/models/alat_models.dart

class Alat {
  final int alatId;
  final String namaAlat;
  final int kategoriId;
  final int stok;
  final String status;
  final String createAt;
  final String? imageUrl;

  Alat({
    required this.alatId,
    required this.namaAlat,
    required this.kategoriId,
    required this.stok,
    required this.status,
    required this.createAt,
    this.imageUrl,
  });

  // Fungsi untuk konversi dari JSON ke objek Alat
  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      alatId: json['alat_id'],
      namaAlat: json['nama_alat'],
      kategoriId: json['kategori_id'],
      stok: json['stok'],
      status: json['status'],
      createAt: json['create_at'],
      imageUrl: json['image_url'],
    );
  }
}
