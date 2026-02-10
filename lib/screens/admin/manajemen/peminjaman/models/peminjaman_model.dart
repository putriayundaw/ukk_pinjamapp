class PeminjamanModel {
  final int? peminjamanId;
  final int? alatId;
  final String? userId;
  final DateTime? tanggalPinjam;
  final DateTime tanggalKembali;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int jumlahAlat;
  final String? petugasId;

  final String? emailPeminjam;
  final String? namaPeminjam;
  final String? namaAlat;
  final String? namaPetugas;

  PeminjamanModel({
    this.peminjamanId,
    this.alatId,
    this.userId,
    this.tanggalPinjam,
    required this.tanggalKembali,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.jumlahAlat,
    this.petugasId,
    this.emailPeminjam,
    this.namaPeminjam,
    this.namaAlat,
    this.namaPetugas,
  });

  factory PeminjamanModel.fromJson(Map<String, dynamic> json) {
    return PeminjamanModel(
      peminjamanId: json['peminjaman_id'],
      alatId: json['alat_id'],
      userId: json['user_id'],
      tanggalPinjam: json['tanggal_pinjam'] != null
          ? DateTime.parse(json['tanggal_pinjam'])
          : null,
      tanggalKembali: DateTime.parse(json['tanggal_kembali']),
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      jumlahAlat: json['jumlah_alat'],
      petugasId: json['petugas_id'],

      emailPeminjam: json['users']?['email'],
      namaAlat: json['alat']?['nama_alat'],
      namaPetugas: json['petugas']?['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peminjaman_id': peminjamanId,
      'alat_id': alatId,
      'user_id': userId,
      'tanggal_pinjam': tanggalPinjam?.toIso8601String(),
      'tanggal_kembali': tanggalKembali.toIso8601String(),
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'jumlah_alat': jumlahAlat,
      'petugas_id': petugasId,
    };
  }
}
