class UserModel {
  String? id;
  String? nama;
  String? email;
  String? role;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.role,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nama,
      'email': email,
      'role': role,
    };
  }
}
