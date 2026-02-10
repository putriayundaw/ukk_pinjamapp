class Pengembalian {
  final int pengembalianId;
  final int peminjamanId;
  final DateTime? tanggalKembaliActual;
  final double denda;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? petugasId;

  Pengembalian({
    required this.pengembalianId,
    required this.peminjamanId,
    this.tanggalKembaliActual,
    this.denda = 0,
    this.status = 'belum dikembalikan',
    required this.createdAt,
    required this.updatedAt,
    this.petugasId,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) => Pengembalian(
        pengembalianId: json['pengembalian_id'],
        peminjamanId: json['peminjaman_id'],
        tanggalKembaliActual: json['tanggal_kembali_actual'] != null
            ? DateTime.parse(json['tanggal_kembali_actual'])
            : null,
        denda: json['denda'] != null ? double.parse(json['denda'].toString()) : 0,
        status: json['status'] ?? 'belum dikembalikan',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        petugasId: json['petugas_id'],
      );

  Map<String, dynamic> toJson() => {
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
