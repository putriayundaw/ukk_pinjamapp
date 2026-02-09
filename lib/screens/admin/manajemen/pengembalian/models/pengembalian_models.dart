// models/pengembalian.dart

import 'dart:convert';

class Pengembalian {
  int pengembalianId;
  int peminjamanId;
  DateTime? tanggalKembaliActual;
  double denda;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String petugasId;

  Pengembalian({
    required this.pengembalianId,
    required this.peminjamanId,
    this.tanggalKembaliActual,
    this.denda = 0,
    this.status = 'belum dikembalikan',
    required this.createdAt,
    required this.updatedAt,
    required this.petugasId,
  });

  // Convert a Pengembalian instance into a map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'pengembalian_id': pengembalianId,
      'peminjaman_id': peminjamanId,
      'tanggal_kembali_actual': tanggalKembaliActual?.toIso8601String(),
      'denda': denda,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'petugas_id': petugasId,
    };
  }

  // Convert a map into a Pengembalian instance (for JSON deserialization)
  factory Pengembalian.fromMap(Map<String, dynamic> map) {
    return Pengembalian(
      pengembalianId: map['pengembalian_id'],
      peminjamanId: map['peminjaman_id'],
      tanggalKembaliActual: map['tanggal_kembali_actual'] != null
          ? DateTime.parse(map['tanggal_kembali_actual'])
          : null,
      denda: map['denda'] ?? 0.0,
      status: map['status'] ?? 'belum dikembalikan',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      petugasId: map['petugas_id'],
    );
  }

  // Convert a Pengembalian instance into a JSON string
  String toJson() => json.encode(toMap());

  // Convert a JSON string into a Pengembalian instance
  factory Pengembalian.fromJson(String source) =>
      Pengembalian.fromMap(json.decode(source));
}
