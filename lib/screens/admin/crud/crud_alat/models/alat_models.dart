// alat_models.dart
class AlatModel {
  int? alatId;
  String namaAlat;
  int stok;
  int kategoriId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String? imageUrl;
  
  // Untuk join dengan kategori
  Map<String, dynamic>? kategori; // {kategori_id: X, nama_kategori: "Nama"}

  AlatModel({
    this.alatId,
    required this.namaAlat,
    required this.stok,
    required this.kategoriId,
    this.status = 'tersedia',
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.kategori,
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      alatId: json['alat_id'],
      namaAlat: json['nama_alat'],
      stok: json['stok'] ?? 0,
      kategoriId: json['kategori_id'],
      status: json['status'] ?? 'tersedia',
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      kategori: json['kategori'] is Map<String, dynamic> ? json['kategori'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (alatId != null) 'alat_id': alatId,
      'nama_alat': namaAlat,
      'stok': stok,
      'kategori_id': kategoriId,
      'status': status,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}