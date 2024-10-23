class Warnet {
  final String kodeTransaksi;
  final String namaPelanggan;
  final String jenisPelanggan;
  final DateTime tglMasuk;
  final DateTime jamMasuk;
  final DateTime jamKeluar;
  final double tarif;

  Warnet({
    required this.kodeTransaksi,
    required this.namaPelanggan,
    required this.jenisPelanggan,
    required this.tglMasuk,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.tarif,
  });

  double hitungLama() {
    return jamKeluar.difference(jamMasuk).inHours.toDouble();
  }

  double hitungDiskon() {
    double lama = hitungLama();
    if (lama > 2) {
      if (jenisPelanggan == "VIP") {
        return tarif * lama * 0.02;
      } else if (jenisPelanggan == "GOLD") {
        return tarif * lama * 0.05;
      }
    }
    return 0;
  }

  double hitungTotalBayar() {
    double lama = hitungLama();
    double diskon = hitungDiskon();
    return (lama * tarif) - diskon;
  }
}