class PengembalianModel {
  final int? pengembalianId;
  final int peminjamanId;
  final DateTime tanggalKembaliActual;
  final double denda;
  final String status;
  final String? petugasId;

  PengembalianModel({
    this.pengembalianId,
    required this.peminjamanId,
    required this.tanggalKembaliActual,
    this.denda = 0,
    this.status = 'belum dikembalikan',
    this.petugasId,
  });

  factory PengembalianModel.fromJson(Map<String, dynamic> json) {
    return PengembalianModel(
      pengembalianId: json['pengembalian_id'],
      peminjamanId: json['peminjaman_id'],
      tanggalKembaliActual: DateTime.parse(json['tanggal_kembali_actual']),
      denda: (json['denda'] ?? 0).toDouble(),
      status: json['status'],
      petugasId: json['petugas_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peminjaman_id': peminjamanId,
      'tanggal_kembali_actual': tanggalKembaliActual.toIso8601String(),
      'denda': denda,
      'status': status,
      'petugas_id': petugasId,
    };
  }
}
