import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/page/barang.dart'
    show ItemBarang, dataBarang, daftarKategori, daftarLokasi;
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';

enum JenisLaporan {
  dataBarang('Laporan Data Barang', 'Daftar seluruh barang di laboratorium'),
  stok('Laporan Stok Barang', 'Status stok barang saat ini'),
  keluar('Laporan Barang Keluar', 'Barang yang sedang atau pernah dipinjam'),
  permintaan('Laporan Permintaan Barang', 'Seluruh permintaan peminjaman');

  const JenisLaporan(this.judul, this.deskripsi);
  final String judul;
  final String deskripsi;
}

class _Hasil {
  const _Hasil(this.judul, this.kolom, this.baris);
  final String judul;
  final List<String> kolom;
  final List<List<String>> baris;
}

String _labelStatus(StatusPinjam s) => switch (s) {
      StatusPinjam.menunggu => 'Menunggu',
      StatusPinjam.dipinjam => 'Dipinjam',
      StatusPinjam.menungguKembali => 'Menunggu Pengembalian',
      StatusPinjam.selesai => 'Selesai',
      StatusPinjam.ditolak => 'Ditolak',
    };

// Ambang sama dengan label stok di halaman Data Barang.
String _statusStok(int stok) {
  if (stok <= 0) return 'Stok Habis';
  if (stok <= 5) return 'Stok Minimum';
  if (stok <= 10) return 'Hampir Habis';
  return 'Aman';
}

/// Laporan Inventaris (Admin, mobile).
class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  JenisLaporan _jenis = JenisLaporan.dataBarang;
  DateTime? _mulai;
  DateTime? _akhir;
  String? _kategori;
  String? _lokasi;
  _Hasil? _hasil;

  bool _cocokBarang(ItemBarang b) =>
      (_kategori == null || b.kategori == _kategori) &&
      (_lokasi == null || b.lokasi == _lokasi);

  bool _dalamTanggal(DateTime d) {
    final t = DateTime(d.year, d.month, d.day);
    if (_mulai != null && t.isBefore(_mulai!)) return false;
    if (_akhir != null && t.isAfter(_akhir!)) return false;
    return true;
  }

  // Filter kategori/lokasi untuk data peminjaman dicocokkan lewat nama barang.
  bool _cocokNama(String nama) {
    if (_kategori == null && _lokasi == null) return true;
    final b = dataBarang.where((x) => x.nama == nama);
    return b.isNotEmpty && _cocokBarang(b.first);
  }

  _Hasil _buat() {
    final semua = PeminjamanRepository.instance.semua;
    switch (_jenis) {
      case JenisLaporan.dataBarang:
        return _Hasil(
          _jenis.judul,
          ['Kode', 'Nama Barang', 'Kategori', 'Lokasi', 'Stok', 'Kondisi'],
          [
            for (final b in dataBarang.where(_cocokBarang))
              [b.kode, b.nama, b.kategori, b.lokasi, '${b.stok}', b.kondisi],
          ],
        );
      case JenisLaporan.stok:
        return _Hasil(
          _jenis.judul,
          ['Kode', 'Nama Barang', 'Kategori', 'Lokasi', 'Stok', 'Status'],
          [
            for (final b in dataBarang.where(_cocokBarang))
              [
                b.kode,
                b.nama,
                b.kategori,
                b.lokasi,
                '${b.stok}',
                _statusStok(b.stok)
              ],
          ],
        );
      case JenisLaporan.keluar:
        return _Hasil(
          _jenis.judul,
          ['Tgl Pinjam', 'Barang', 'Jumlah', 'Peminjam', 'Batas Kembali', 'Status'],
          [
            for (final p in semua)
              if (p.status != StatusPinjam.menunggu &&
                  p.status != StatusPinjam.ditolak &&
                  _dalamTanggal(p.tglPinjam) &&
                  _cocokNama(p.barang))
                [
                  formatTanggal(p.tglPinjam),
                  p.barang,
                  '${p.jumlah}',
                  p.peminjam,
                  formatTanggal(p.batasKembali),
                  _labelStatus(p.status),
                ],
          ],
        );
      case JenisLaporan.permintaan:
        return _Hasil(
          _jenis.judul,
          ['Tanggal', 'Peminjam', 'Barang', 'Jumlah', 'Keperluan', 'Status'],
          [
            for (final p in semua)
              if (_dalamTanggal(p.tglPinjam) && _cocokNama(p.barang))
                [
                  formatTanggal(p.tglPinjam),
                  p.peminjam,
                  p.barang,
                  '${p.jumlah}',
                  p.keperluan,
                  _labelStatus(p.status),
                ],
          ],
        );
    }
  }

  bool _rentangValid() {
    if (_mulai != null && _akhir != null && _akhir!.isBefore(_mulai!)) {
      tampilkanSnack(context, 'Tanggal akhir tidak boleh sebelum tanggal mulai');
      return false;
    }
    return true;
  }

  void _preview() {
    if (!_rentangValid()) return;
    setState(() => _hasil = _buat());
  }

  Future<void> _salinCsv() async {
    if (!_rentangValid()) return;
    final h = _buat();
    setState(() => _hasil = h);
    String q(String s) => '"${s.replaceAll('"', '""')}"';
    final csv = [h.kolom, ...h.baris].map((r) => r.map(q).join(',')).join('\n');
    await Clipboard.setData(ClipboardData(text: csv));
    if (!mounted) return;
    tampilkanSnack(context, 'CSV disalin. Tempel di Excel atau Google Sheets.');
  }

  Future<void> _pilihTanggal(DateTime? awal, ValueChanged<DateTime> hasil) async {
    final d = await showDatePicker(
      context: context,
      initialDate: awal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) hasil(DateTime(d.year, d.month, d.day));
  }

  Widget _tanggal(String label, DateTime? nilai, ValueChanged<DateTime> set) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(label),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _pilihTanggal(nilai, (d) => setState(() => set(d))),
          child: InputDecorator(
            isEmpty: nilai == null,
            decoration: inputDecoration(
              hintText: 'dd/mm/yyyy',
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
            ),
            child: Text(nilai == null ? '' : formatTanggal(nilai)),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String semuaLabel, List<String> opsi,
      String? nilai, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String?>(
          value: nilai,
          isExpanded: true,
          decoration: inputDecoration(),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(semuaLabel)),
            for (final o in opsi) DropdownMenuItem<String?>(value: o, child: Text(o)),
          ],
          onChanged: (v) => setState(() => onChanged(v)),
        ),
      ],
    );
  }

  Widget _kartuJenis(JenisLaporan j) {
    final aktif = _jenis == j;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() {
        _jenis = j;
        _hasil = null;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: aktif ? kBiruTua : kBorder, width: aktif ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(aktif ? Icons.radio_button_checked : Icons.radio_button_off,
                color: aktif ? kBiruTua : kTextMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(j.judul,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: kTextDark)),
                  Text(j.deskripsi,
                      style: const TextStyle(fontSize: 12.5, color: kTextMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabel(_Hasil h) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text('${h.judul} · ${h.baris.length} baris',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kTextDark)),
          ),
          if (h.baris.isEmpty)
            const KosongState('Tidak ada data untuk filter ini.')
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 56,
                columnSpacing: 20,
                columns: [
                  for (final c in h.kolom)
                    DataColumn(
                        label: Text(c,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w600))),
                ],
                rows: [
                  for (final r in h.baris)
                    DataRow(cells: [
                      for (final c in r)
                        DataCell(Text(c, style: const TextStyle(fontSize: 12.5))),
                    ]),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'laporan.dart'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const JudulHalaman(
            judul: 'Laporan Inventaris',
            subjudul: 'Buat dan kelola laporan inventaris laboratorium',
          ),
          for (final j in JenisLaporan.values) _kartuJenis(j),
          const JudulBagian('Filter Laporan'),
          duaKolom(
            _tanggal('Tanggal Mulai', _mulai, (d) => _mulai = d),
            _tanggal('Tanggal Akhir', _akhir, (d) => _akhir = d),
          ),
          const SizedBox(height: 12),
          _dropdown('Kategori Barang', 'Semua Kategori', daftarKategori,
              _kategori, (v) => _kategori = v),
          const SizedBox(height: 12),
          _dropdown('Lokasi Penyimpanan', 'Semua Lokasi', daftarLokasi,
              _lokasi, (v) => _lokasi = v),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: AksiTombol(
                      label: 'Preview Laporan', utama: true, onPressed: _preview)),
              const SizedBox(width: 8),
              Expanded(
                  child: AksiTombol(
                      label: 'Salin CSV (Excel)', onPressed: _salinCsv)),
            ],
          ),
          const JudulBagian('Preview Laporan'),
          if (_hasil == null)
            const KosongState(
                'Pilih jenis laporan dan filter, lalu tekan Preview Laporan.',
                icon: Icons.description_outlined)
          else
            _tabel(_hasil!),
        ],
      ),
    );
  }
}
