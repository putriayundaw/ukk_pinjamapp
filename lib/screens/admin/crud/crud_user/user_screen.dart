import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/create_user.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/update_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pinjam_ukk/controller/user_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/models/users_model.dart';
import 'widgets/user_role_filter.dart';
import 'widgets/user_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController searchController = TextEditingController();

  int selectedRole = 0;

  @override
  void initState() {
    super.initState();
    userController.getUsers(); // ambil data dari Supabase
  }

  void _confirmDelete(UserModel user) {
    Get.defaultDialog(
      title: 'Hapus Pengguna',
      middleText:
          'Apakah Anda yakin ingin menghapus ${user.nama ?? 'pengguna ini'}?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (user.id != null) {
          userController.deleteUser(user.id!);
        }
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Pengguna',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.to(() =>  CreateUser());
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchField(),
            const SizedBox(height: 12),
            UserRoleFilter(
              selectedRole: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: _userList()),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Cari pengguna',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _userList() {
    return Obx(() {
      if (userController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (userController.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            userController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      final filteredUsers = userController.usersList.where((user) {
        final matchesSearch =
            (user.email?.toLowerCase() ?? '')
                .contains(searchController.text.toLowerCase());

        // SAMAKAN DENGAN DB (huruf kecil)
       final matchesRole =
  selectedRole == 0 ||
  (selectedRole == 1 && user.role == 'petugas') ||
  (selectedRole == 2 && user.role == 'peminjam');

        return matchesSearch && matchesRole;
      }).toList();

      if (filteredUsers.isEmpty) {
        return const Center(child: Text('Tidak ada pengguna ditemukan'));
      }

      return ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return UserCard(
            key: ValueKey(user.id ?? index),
            user: user,
            onEdit: () => Get.to(() => UpdateUser(user: user)),
            onDelete: () => _confirmDelete(user),
          );
        },
      );
    });
  }
}
