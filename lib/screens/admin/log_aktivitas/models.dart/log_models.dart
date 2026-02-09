
class LogAktivitas {
  int? idAktivitas;
  String? idUser; // UUID
  String aktivitas;
  DateTime? waktu;
  String? petugasId; // UUID

  LogAktivitas({
    this.idAktivitas,
    this.idUser,
    required this.aktivitas,
    this.waktu,
    this.petugasId,
  });

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    return LogAktivitas(
      idAktivitas: json['id_aktivitas'],
      idUser: json['id_user'],
      aktivitas: json['aktivitas'],
      waktu: json['waktu'] != null ? DateTime.parse(json['waktu']) : null,
      petugasId: json['petugas_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idAktivitas != null) 'id_aktivitas': idAktivitas,
      'id_user': idUser,
      'aktivitas': aktivitas,
      'waktu': waktu?.toIso8601String(),
      'petugas_id': petugasId,
    };
  }
}
