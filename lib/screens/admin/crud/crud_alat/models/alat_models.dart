// models/alat_model.dart
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

  // Factory method untuk memparsing JSON menjadi objek Alat
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

  // Method untuk mengkonversi objek Alat menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'alat_id': alatId,
      'nama_alat': namaAlat,
      'kategori_id': kategoriId,
      'stok': stok,
      'status': status,
      'create_at': createAt,
      'image_url': imageUrl,
    };
  }
}
