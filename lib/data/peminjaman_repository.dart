import 'package:flutter/foundation.dart';
import 'package:inventaris_v_pbm/data/user_repository.dart';

/// Status dibuat terpisah agar "permintaan baru" dan "pengajuan pengembalian"
/// tidak tercampur (di versi PHP keduanya memakai nilai `pending`).
enum StatusPinjam { menunggu, dipinjam, menungguKembali, selesai, ditolak }

const List<String> _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

class Peminjaman {
  const Peminjaman({
    required this.id,
    required this.userId,
    required this.peminjam,
    required this.npm,
    required this.barang,
    required this.jumlah,
    required this.keperluan,
    required this.tglPinjam,
    required this.batasKembali,
    this.status = StatusPinjam.menunggu,
    this.catatanAdmin = '',
  });

  final int id;
  final String userId;
  final String peminjam;
  final String npm;
  final String barang;
  final int jumlah;
  final String keperluan;
  final DateTime tglPinjam;
  final DateTime batasKembali;
  final StatusPinjam status;
  final String catatanAdmin;

  Peminjaman copyWith({StatusPinjam? status, String? catatanAdmin}) {
    return Peminjaman(
      id: id,
      userId: userId,
      peminjam: peminjam,
      npm: npm,
      barang: barang,
      jumlah: jumlah,
      keperluan: keperluan,
      tglPinjam: tglPinjam,
      batasKembali: batasKembali,
      status: status ?? this.status,
      catatanAdmin: catatanAdmin ?? this.catatanAdmin,
    );
  }
}

/// PENYIMPANAN SEMENTARA (in-memory), pola sama dengan UserRepository.
/// Saat backend tersedia, ganti isi method dengan pemanggilan API.
class PeminjamanRepository extends ChangeNotifier {
  PeminjamanRepository._() {
    _seed();
  }

  static final PeminjamanRepository instance = PeminjamanRepository._();

  final List<Peminjaman> _data = [];
  int _nextId = 1;

  List<Peminjaman> get semua => List.unmodifiable(_data);

  List<Peminjaman> milik(String userId) =>
      _data.where((e) => e.userId == userId).toList();

  /// Dipanggil dari Katalog saat mahasiswa mengajukan peminjaman.
  Peminjaman ajukan({
    required String userId,
    required String peminjam,
    required String npm,
    required String barang,
    required int jumlah,
    required String keperluan,
    required DateTime tglPinjam,
    required DateTime batasKembali,
  }) {
    final item = Peminjaman(
      id: _nextId++,
      userId: userId,
      peminjam: peminjam,
      npm: npm,
      barang: barang,
      jumlah: jumlah,
      keperluan: keperluan,
      tglPinjam: tglPinjam,
      batasKembali: batasKembali,
    );
    _data.insert(0, item);
    notifyListeners();
    return item;
  }

  /// Hanya permintaan yang masih menunggu yang boleh dibatalkan.
  void batalkan(int id) {
    _data.removeWhere((e) => e.id == id && e.status == StatusPinjam.menunggu);
    notifyListeners();
  }

  void setujui(int id, {String catatan = ''}) =>
      _ubah(id, StatusPinjam.dipinjam, catatan);
  void tolak(int id, {String catatan = ''}) =>
      _ubah(id, StatusPinjam.ditolak, catatan);
  void ajukanPengembalian(int id) =>
      _ubah(id, StatusPinjam.menungguKembali, null);
  void selesaikanPengembalian(int id, {String catatan = ''}) =>
      _ubah(id, StatusPinjam.selesai, catatan);
  void tolakPengembalian(int id, {String catatan = ''}) =>
      _ubah(id, StatusPinjam.dipinjam, catatan);

  void _ubah(int id, StatusPinjam status, String? catatan) {
    final i = _data.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _data[i] = _data[i].copyWith(
      status: status,
      catatanAdmin: (catatan == null || catatan.isEmpty) ? null : catatan,
    );
    notifyListeners();
  }

  void _seed() {
    final now = DateTime.now();
    DateTime hari(int offset) => DateTime(now.year, now.month, now.day)
        .add(Duration(days: offset));
    final halvina =
        UserRepository.instance.findByEmail('2410631170071@unsika.ac.id');
    final uid = halvina?.id ?? 'demo';
    final nama = halvina?.nama ?? 'Halvina Farras Savitri';
    final npm = halvina?.npmNidn ?? '2410631170071';

    void tambah(String userId, String peminjam, String npmUser, String barang,
        int jumlah, String keperluan, int pinjam, int kembali,
        StatusPinjam status, [String catatan = '']) {
      _data.add(Peminjaman(
        id: _nextId++,
        userId: userId,
        peminjam: peminjam,
        npm: npmUser,
        barang: barang,
        jumlah: jumlah,
        keperluan: keperluan,
        tglPinjam: hari(pinjam),
        batasKembali: hari(kembali),
        status: status,
        catatanAdmin: catatan,
      ));
    }

    tambah(uid, nama, npm, 'Arduino Uno', 2, 'Tugas Akhir', 0, 12,
        StatusPinjam.menunggu);
    tambah(uid, nama, npm, 'ESP32', 2, 'Praktikum IoT', -3, 4,
        StatusPinjam.dipinjam, 'Harap dijaga dan dikembalikan tepat waktu.');
    tambah(uid, nama, npm, 'DHT 11', 3, 'Penelitian', -6, 1,
        StatusPinjam.menungguKembali);
    tambah(uid, nama, npm, 'Sensor Ultrasonik', 1, 'Praktikum', -14, -7,
        StatusPinjam.selesai);
    tambah(uid, nama, npm, 'Raspberry Pi Pico', 1, 'Tugas Akhir', -10, 5,
        StatusPinjam.ditolak, 'Stok sedang dipakai praktikum.');
    tambah('d1', 'Anisa Diyah Ayu Lestari', '2110631170001', 'Kabel LAN UTP',
        5, 'Praktikum Jaringan', 0, 3, StatusPinjam.menunggu);
    tambah('d2', 'Rifqy Kurniawan Fattahillah', '2110631170003', 'Arduino Uno',
        1, 'Praktikum IoT', -4, 3, StatusPinjam.dipinjam);
    tambah('d3', 'Hazel Muhammad Naufal Ribawa', '2110631170004', 'ESP32', 1,
        'Penelitian', -8, -1, StatusPinjam.menungguKembali);
    tambah('d4', 'Regina Inryanti Simanjuntak', '2110631170005', 'DHT 11', 2,
        'Tugas Akhir', 0, 9, StatusPinjam.menunggu);
    tambah('d1', 'Anisa Diyah Ayu Lestari', '2110631170001',
        'Sensor Ultrasonik', 1, 'Praktikum', -20, -13, StatusPinjam.selesai);
  }
}
