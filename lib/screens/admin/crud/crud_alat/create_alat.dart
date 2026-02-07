import 'package:flutter/material.dart';

class CreateAlat extends StatelessWidget {
  const CreateAlat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE PLACEHOLDER
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Add Image',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// PRODUCT NAME
            TextField(
              decoration: _inputDecoration(
                'Nama Alat',
                Icons.shopping_cart,
              ),
            ),

            const SizedBox(height: 20),

            /// STOCK
            TextField(
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                'Jumlah',
                Icons.inventory_2,
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            /// CATEGORY DROPDOWN (UI ONLY)
            DropdownButtonFormField<String>(
              decoration: _inputDecoration(
                'Pilih Kategori',
                Icons.category,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Elektronik',
                  child: Text('Elektronik'),
                ),
                DropdownMenuItem(
                  value: 'Kesenian',
                  child: Text('Kesenian'),
                ),
                DropdownMenuItem(
                  value: 'Olahraga',
                  child: Text('Olahraga'),
                ),
              ],
              onChanged: (_) {},
            ),

            const SizedBox(height: 40),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambahkan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
