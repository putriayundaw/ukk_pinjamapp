// models/peminjaman.dart

import 'dart:convert';

class Peminjaman {
  int peminjamanId;
  int alatId;
  String userId;
  DateTime tanggalPinjam;
  DateTime tanggalKembali;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int jumlahAlat;
  String petugasId;

  Peminjaman({
    required this.peminjamanId,
    required this.alatId,
    required this.userId,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.jumlahAlat,
    required this.petugasId,
  });

  // Convert a Peminjaman instance into a map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'peminjaman_id': peminjamanId,
      'alat_id': alatId,
      'user_id': userId,
      'tanggal_pinjam': tanggalPinjam.toIso8601String(),
      'tanggal_kembali': tanggalKembali.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'jumlah_alat': jumlahAlat,
      'petugas_id': petugasId,
    };
  }

  // Convert a map into a Peminjaman instance (for JSON deserialization)
  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    return Peminjaman(
      peminjamanId: map['peminjaman_id'],
      alatId: map['alat_id'],
      userId: map['user_id'],
      tanggalPinjam: DateTime.parse(map['tanggal_pinjam']),
      tanggalKembali: DateTime.parse(map['tanggal_kembali']),
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      jumlahAlat: map['jumlah_alat'],
      petugasId: map['petugas_id'],
    );
  }

  // Convert a Peminjaman instance into a JSON string
  String toJson() => json.encode(toMap());

  // Convert a JSON string into a Peminjaman instance
  factory Peminjaman.fromJson(String source) => Peminjaman.fromMap(json.decode(source));
}
