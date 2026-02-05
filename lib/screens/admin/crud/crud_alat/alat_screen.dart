// screens/alat_screen.dart
import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlatScreen extends StatelessWidget {
  final AlatController alatController = Get.put(AlatController());

  @override
  Widget build(BuildContext context) {
    // Memanggil loadAlat() saat screen pertama kali dibuka
    alatController.loadAlat();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alat',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Logika untuk navigasi ke halaman tambah alat (belum diimplementasikan)
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Elektronik")),
                ElevatedButton(onPressed: () {}, child: Text("Olahraga")),
                ElevatedButton(onPressed: () {}, child: Text("Kesenian")),
                ElevatedButton(onPressed: () {}, child: Text("Tambah")),
              ],
            ),
            SizedBox(height: 16),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Daftar Card Alat
            Expanded(
              child: Obx(() {
                // Jika data sedang dimuat
                if (alatController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Jika data telah dimuat
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemCount: alatController.alatList.length,
                  itemBuilder: (context, index) {
                    final alat = alatController.alatList[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gambar placeholder
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Nama alat
                          Text(
                            alat.namaAlat,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Tombol aksi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Tambah"),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  alatController.deleteAlat(alat.alatId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
