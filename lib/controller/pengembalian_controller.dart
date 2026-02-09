// controllers/pengembalian_controller.dart

import 'dart:convert';
import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/pengembalian/models/pengembalian_models.dart';
import 'package:http/http.dart' as http;

class PengembalianController {
  final String baseUrl;

  PengembalianController({required this.baseUrl});

  // Create Pengembalian
  Future<Pengembalian> createPengembalian(Pengembalian pengembalian) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pengembalian'),
      headers: {'Content-Type': 'application/json'},
      body: pengembalian.toJson(),
    );

    if (response.statusCode == 201) {
      // Jika request sukses, parsing response ke model Pengembalian
      return Pengembalian.fromJson(response.body);
    } else {
      throw Exception('Gagal membuat pengembalian');
    }
  }

  // Get All Pengembalian
  Future<List<Pengembalian>> getAllPengembalian() async {
    final response = await http.get(Uri.parse('$baseUrl/pengembalian'));

    if (response.statusCode == 200) {
      // Parsing JSON response menjadi list Pengembalian
      List<dynamic> pengembalianList = json.decode(response.body);
      return pengembalianList
          .map((json) => Pengembalian.fromMap(json))
          .toList();
    } else {
      throw Exception('Gagal mengambil data pengembalian');
    }
  }

  // Get Pengembalian by ID
  Future<Pengembalian> getPengembalianById(int pengembalianId) async {
    final response = await http.get(Uri.parse('$baseUrl/pengembalian/$pengembalianId'));

    if (response.statusCode == 200) {
      return Pengembalian.fromJson(response.body);
    } else {
      throw Exception('Pengembalian tidak ditemukan');
    }
  }

  // Update Pengembalian
  Future<Pengembalian> updatePengembalian(int pengembalianId, String status, {DateTime? tanggalKembaliActual, double denda = 0.0}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pengembalian/$pengembalianId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'status': status,
        'tanggal_kembali_actual': tanggalKembaliActual?.toIso8601String(),
        'denda': denda,
      }),
    );

    if (response.statusCode == 200) {
      return Pengembalian.fromJson(response.body);
    } else {
      throw Exception('Gagal memperbarui pengembalian');
    }
  }

  // Delete Pengembalian
  Future<void> deletePengembalian(int pengembalianId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/pengembalian/$pengembalianId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pengembalian');
    }
  }
}
