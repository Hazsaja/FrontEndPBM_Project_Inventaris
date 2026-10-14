import 'package:flutter/foundation.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/data/user_repository.dart';

/// Status dibuat terpisah agar "permintaan baru" dan "pengajuan pengembalian"
/// tidak tercampur (di versi PHP keduanya memakai nilai `pending`).
enum StatusPinjam { menunggu, dipinjam, menungguKembali, selesai, ditolak }

const List<String> _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
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

enum JenisAktivitas { peminjaman, pengembalian }

/// Satu baris log aktivitas peminjaman/pengembalian.
class Aktivitas {
  const Aktivitas({
    required this.waktu,
    required this.pelaku,
    required this.teks,
    required this.jenis,
  });

  final DateTime waktu;
  final String pelaku;
  final String teks;
  final JenisAktivitas jenis;
}

String waktuRelatif(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'baru saja';
  if (d.inMinutes < 60) return '${d.inMinutes} menit lalu';
  if (d.inHours < 24) return '${d.inHours} jam lalu';
  return '${d.inDays} hari lalu';
}

/// PENYIMPANAN SEMENTARA (in-memory), pola sama dengan UserRepository.
/// Saat backend tersedia, ganti isi method dengan pemanggilan API.
class PeminjamanRepository extends ChangeNotifier {
  PeminjamanRepository._() {
    _seed();
  }

  static final PeminjamanRepository instance = PeminjamanRepository._();

  final List<Peminjaman> _data = [];
  final List<Aktivitas> _log = [];
  int _nextId = 1;

  List<Peminjaman> get semua => List.unmodifiable(_data);

  /// Log aktivitas, terbaru di urutan pertama.
  List<Aktivitas> get aktivitas => List.unmodifiable(_log);

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
    _catat(JenisAktivitas.peminjaman, peminjam,
        'mengajukan peminjaman $barang ($jumlah pcs)');
    notifyListeners();
    return item;
  }

  /// Hanya permintaan yang masih menunggu yang boleh dibatalkan.
  void batalkan(int id) {
    final p = _cari(id);
    if (p != null && p.status == StatusPinjam.menunggu) {
      _catat(JenisAktivitas.peminjaman, p.peminjam,
          'membatalkan permintaan ${p.barang}');
    }
    _data.removeWhere((e) => e.id == id && e.status == StatusPinjam.menunggu);
    notifyListeners();
  }

  void setujui(int id, {String catatan = ''}) => _ubah(
      id,
      StatusPinjam.dipinjam,
      catatan,
      JenisAktivitas.peminjaman,
      (p) => 'menyetujui permintaan ${p.peminjam}: ${p.barang}',
      true);
  void tolak(int id, {String catatan = ''}) => _ubah(
      id,
      StatusPinjam.ditolak,
      catatan,
      JenisAktivitas.peminjaman,
      (p) => 'menolak permintaan ${p.peminjam}: ${p.barang}',
      true);
  void ajukanPengembalian(int id) => _ubah(
      id,
      StatusPinjam.menungguKembali,
      null,
      JenisAktivitas.pengembalian,
      (p) => 'mengajukan pengembalian ${p.barang}',
      false);
  void selesaikanPengembalian(int id, {String catatan = ''}) => _ubah(
      id,
      StatusPinjam.selesai,
      catatan,
      JenisAktivitas.pengembalian,
      (p) => 'menyelesaikan pengembalian ${p.peminjam}: ${p.barang}',
      true);
  void tolakPengembalian(int id, {String catatan = ''}) => _ubah(
      id,
      StatusPinjam.dipinjam,
      catatan,
      JenisAktivitas.pengembalian,
      (p) => 'menolak pengembalian ${p.peminjam}: ${p.barang}',
      true);

  Peminjaman? _cari(int id) {
    for (final e in _data) {
      if (e.id == id) return e;
    }
    return null;
  }

  void _catat(JenisAktivitas jenis, String pelaku, String teks,
      [DateTime? waktu]) {
    _log.insert(
        0,
        Aktivitas(
            waktu: waktu ?? DateTime.now(),
            pelaku: pelaku,
            teks: teks,
            jenis: jenis));
  }

  void _ubah(int id, StatusPinjam status, String? catatan, JenisAktivitas jenis,
      String Function(Peminjaman) teks, bool olehAdmin) {
    final i = _data.indexWhere((e) => e.id == id);
    if (i < 0) return;
    final lama = _data[i];
    _catat(
        jenis,
        olehAdmin
            ? (AuthService.instance.currentUser?.nama ?? 'Admin')
            : lama.peminjam,
        teks(lama));
    _data[i] = _data[i].copyWith(
      status: status,
      catatanAdmin: (catatan == null || catatan.isEmpty) ? null : catatan,
    );
    notifyListeners();
  }

  void _seed() {
    final now = DateTime.now();
    DateTime hari(int offset) =>
        DateTime(now.year, now.month, now.day).add(Duration(days: offset));
    final halvina =
        UserRepository.instance.findByEmail('2410631170071@unsika.ac.id');
    final uid = halvina?.id ?? 'demo';
    final nama = halvina?.nama ?? 'Halvina Farras Savitri';
    final npm = halvina?.npmNidn ?? '2410631170071';

    void tambah(
        String userId,
        String peminjam,
        String npmUser,
        String barang,
        int jumlah,
        String keperluan,
        int pinjam,
        int kembali,
        StatusPinjam status,
        [String catatan = '']) {
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
    tambah('d1', 'Anisa Diyah Ayu Lestari', '2110631170001', 'Kabel LAN UTP', 5,
        'Praktikum Jaringan', 0, 3, StatusPinjam.menunggu);
    tambah('d2', 'Rifqy Kurniawan Fattahillah', '2110631170003', 'Arduino Uno',
        1, 'Praktikum IoT', -4, 3, StatusPinjam.dipinjam);
    tambah('d3', 'Hazel Muhammad Naufal Ribawa', '2110631170004', 'ESP32', 1,
        'Penelitian', -8, -1, StatusPinjam.menungguKembali);
    tambah('d4', 'Regina Inryanti Simanjuntak', '2110631170005', 'DHT 11', 2,
        'Tugas Akhir', 0, 9, StatusPinjam.menunggu);
    tambah('d1', 'Anisa Diyah Ayu Lestari', '2110631170001',
        'Sensor Ultrasonik', 1, 'Praktikum', -20, -13, StatusPinjam.selesai);

    void log(JenisAktivitas j, String pelaku, String teks, Duration lalu) =>
        _catat(j, pelaku, teks, now.subtract(lalu));
    // Dari yang terlama ke terbaru (insert(0) membuat yang terakhir di atas).
    log(
        JenisAktivitas.pengembalian,
        'Admin Laboratorium',
        'menyelesaikan pengembalian Anisa Diyah Ayu Lestari: Sensor Ultrasonik',
        const Duration(days: 2));
    log(
        JenisAktivitas.peminjaman,
        'Admin Laboratorium',
        'menyetujui permintaan $nama: ESP32',
        const Duration(days: 1, hours: 2));
    log(
        JenisAktivitas.peminjaman,
        'Admin Laboratorium',
        'menolak permintaan $nama: Raspberry Pi Pico',
        const Duration(hours: 20));
    log(JenisAktivitas.pengembalian, 'Hazel Muhammad Naufal Ribawa',
        'mengajukan pengembalian ESP32', const Duration(hours: 5));
    log(JenisAktivitas.pengembalian, nama, 'mengajukan pengembalian DHT 11',
        const Duration(hours: 2));
    log(JenisAktivitas.peminjaman, 'Regina Inryanti Simanjuntak',
        'mengajukan peminjaman DHT 11 (2 pcs)', const Duration(minutes: 40));
    log(
        JenisAktivitas.peminjaman,
        nama,
        'mengajukan peminjaman Arduino Uno (2 pcs)',
        const Duration(minutes: 10));
  }
}
