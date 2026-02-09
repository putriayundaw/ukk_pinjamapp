class AlatModel {
  final int? alatId;
  final String namaAlat;
  final int kategoriId;
  final int stok;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  AlatModel({
    this.alatId,
    required this.namaAlat,
    required this.kategoriId,
    required this.stok,
    this.status = 'available', // Default value
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imageUrl,
  })  : this.createdAt = createdAt ?? DateTime.now(), // Default to current time if not provided
        this.updatedAt = updatedAt ?? DateTime.now(); // Default to current time if not provided

  // Factory method to create an instance of AlatModel from JSON
  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      alatId: json['alat_id'],
      namaAlat: json['nama_alat'],
      kategoriId: json['kategori_id'],
      stok: json['stok'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imageUrl: json['image_url'],
    );
  }

  // Method to convert AlatModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'alat_id': alatId,
      'nama_alat': namaAlat,
      'kategori_id': kategoriId,
      'stok': stok,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}
