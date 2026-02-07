import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/create_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'widgets/user_role_filter.dart';
import 'widgets/user_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int selectedRole = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengguna',
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
            Get.to(() => const CreateUser());
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
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return UserCard(
          name: 'Putri Ayunda',
          role: selectedRole == 0 ? 'Petugas' : 'Peminjam',
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}
