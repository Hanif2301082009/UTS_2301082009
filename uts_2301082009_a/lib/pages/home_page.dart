import 'package:flutter/material.dart';
import 'pelanggan_page.dart';
import 'warnet_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warnet Hanif'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                'Menu Warnet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Pelanggan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PelangganPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Warnet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WarnetPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const DrawerHeader(
        child: Text('Hanif al zikri \nNIM : 2301082009'),
      ),
    );
  }
}