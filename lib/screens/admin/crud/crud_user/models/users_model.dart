class UserModel {
  final String id;
  final String nama;
  final String role;
  final DateTime createdAt;
  final String email;
  final String password;

  // Constructor
  UserModel({
    required this.id,
    required this.nama,
    required this.role,
    required this.createdAt,
    required this.email,
    required this.password,
  });

  // Factory method untuk membuat instance UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['nama'],
      role: json['role'] ?? 'peminjam',  // Default 'peminjam' jika role tidak ada
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'],
      password: json['password'],
    );
  }

  // Method untuk mengonversi model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'password': password,
    };
  }
}
