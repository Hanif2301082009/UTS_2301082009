import 'package:flutter/material.dart';
import '../models/warnet.dart';

class WarnetPage extends StatefulWidget {
  const WarnetPage({super.key});

  @override
  State<WarnetPage> createState() => _WarnetPageState();
}

class _WarnetPageState extends State<WarnetPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = _FormControllers();
  String _jenisPelanggan = 'Biasa';
  final List<String> _jenisOptions = ['Biasa', 'VIP', 'GOLD'];
  DateTime _tglMasuk = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Warnet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(_controllers.kodeTransaksi, 'Kode Transaksi'),
              _buildInputField(_controllers.namaPelanggan, 'Nama Pelanggan'),
              _buildJenisPelangganDropdown(),
              _buildInputField(
                _controllers.tarif, 
                'Tarif per Jam',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(_controllers.jamMasuk, 'Jam Masuk (HH:mm)'),
              _buildInputField(_controllers.jamKeluar, 'Jam Keluar (HH:mm)'),
              const SizedBox(height: 16),
              _buildHitungButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller, 
    String label, 
    {TextInputType? keyboardType}
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: (value) => value?.isEmpty ?? true ? 'Mohon isi $label' : null,
    );
  }

  Widget _buildJenisPelangganDropdown() {
    return DropdownButtonFormField<String>(
      value: _jenisPelanggan,
      decoration: const InputDecoration(labelText: 'Jenis Pelanggan'),
      items: _jenisOptions.map((value) => 
        DropdownMenuItem(value: value, child: Text(value))
      ).toList(),
      onChanged: (newValue) => setState(() => _jenisPelanggan = newValue!),
    );
  }

  Widget _buildHitungButton() {
    return ElevatedButton(
      onPressed: _hitungPembayaran,
      child: const Text('Hitung'),
    );
  }

  void _hitungPembayaran() {
    if (!_formKey.currentState!.validate()) return;

    final transaksi = Warnet(
      kodeTransaksi: _controllers.kodeTransaksi.text,
      namaPelanggan: _controllers.namaPelanggan.text,
      jenisPelanggan: _jenisPelanggan,
      tglMasuk: _tglMasuk,
      jamMasuk: _parseDateTime(_controllers.jamMasuk.text),
      jamKeluar: _parseDateTime(_controllers.jamKeluar.text),
      tarif: double.parse(_controllers.tarif.text),
    );

    _showHasilPerhitungan(transaksi);
  }

  DateTime _parseDateTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year, now.month, now.day,
      int.parse(parts[0]), int.parse(parts[1]),
    );
  }

  void _showHasilPerhitungan(Warnet transaksi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lama: ${transaksi.hitungLama()} jam'),
            Text('Diskon: Rp ${transaksi.hitungDiskon()}'),
            Text('Total Bayar: Rp ${transaksi.hitungTotalBayar()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }
}

// Kelas pembantu untuk mengelola controller
class _FormControllers {
  final kodeTransaksi = TextEditingController();
  final namaPelanggan = TextEditingController();
  final tarif = TextEditingController();
  final jamMasuk = TextEditingController();
  final jamKeluar = TextEditingController();

  void dispose() {
    kodeTransaksi.dispose();
    namaPelanggan.dispose();
    tarif.dispose();
    jamMasuk.dispose();
    jamKeluar.dispose();
  }
}
