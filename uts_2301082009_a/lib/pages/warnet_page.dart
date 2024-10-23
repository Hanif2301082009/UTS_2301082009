import 'package:flutter/material.dart';
import '../models/warnet.dart';

class WarnetPage extends StatefulWidget {
  const WarnetPage({super.key});

  @override
  State<WarnetPage> createState() => _WarnetPageState();
}

class _WarnetPageState extends State<WarnetPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeTransaksiController = TextEditingController();
  final _namaPelangganController = TextEditingController();
  String _jenisPelanggan = 'Biasa';
  final _tarifController = TextEditingController();
  DateTime _tglMasuk = DateTime.now();
  TimeOfDay _jamMasuk = TimeOfDay.now();
  TimeOfDay _jamKeluar = TimeOfDay.now();

  final List<String> _jenisOptions = ['Biasa', 'VIP', 'GOLD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Warnet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kodeTransaksiController,
                decoration: const InputDecoration(
                  labelText: 'Kode Transaksi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi kode transaksi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaPelangganController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi nama pelanggan';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisPelanggan,
                decoration: const InputDecoration(
                  labelText: 'Jenis Pelanggan',
                ),
                items: _jenisOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisPelanggan = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _tarifController,
                decoration: const InputDecoration(
                  labelText: 'Tarif per Jam',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi tarif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _jamMasuk,
                  );
                  if (picked != null) {
                    setState(() {
                      _jamMasuk = picked;
                    });
                  }
                },
                child: Text('Pilih Jam Masuk: ${_jamMasuk.format(context)}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _jamKeluar,
                  );
                  if (picked != null) {
                    setState(() {
                      _jamKeluar = picked;
                    });
                  }
                },
                child: Text('Pilih Jam Keluar: ${_jamKeluar.format(context)}'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Hitung total bayar
                    DateTime now = DateTime.now();
                    DateTime jamMasukDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      _jamMasuk.hour,
                      _jamMasuk.minute,
                    );
                    DateTime jamKeluarDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      _jamKeluar.hour,
                      _jamKeluar.minute,
                    );

                    Warnet transaksi = Warnet(
                      kodeTransaksi: _kodeTransaksiController.text,
                      namaPelanggan: _namaPelangganController.text,
                      jenisPelanggan: _jenisPelanggan,
                      tglMasuk: _tglMasuk,
                      jamMasuk: jamMasukDateTime,
                      jamKeluar: jamKeluarDateTime,
                      tarif: double.parse(_tarifController.text),
                    );

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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Hitung'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kodeTransaksiController.dispose();
    _namaPelangganController.dispose();
    _tarifController.dispose();
    super.dispose();
  }
}