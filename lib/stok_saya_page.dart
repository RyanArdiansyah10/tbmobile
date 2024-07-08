import 'package:flutter/material.dart';
import 'tambah_stok_page.dart';
import 'lihat_stok_page.dart';
import 'edit_stok_page.dart';

class StokSayaPage extends StatelessWidget {
  const StokSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Saya'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, Colors.teal.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildButton(
                  context,
                  'Tambah Stok',
                  Icons.add,
                  Colors.teal,
                  TambahStokPage(),
                ),
                const SizedBox(height: 16),
                _buildButton(
                  context,
                  'Lihat Stok',
                  Icons.visibility,
                  Colors.orange,
                  LihatStokPage(),
                ),
                const SizedBox(height: 16),
                _buildButton(
                  context,
                  'Edit Stok',
                  Icons.edit,
                  Colors.purple,
                  const EditStokPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
