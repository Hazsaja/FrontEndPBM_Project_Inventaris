import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/sidennavbar/customAppBar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

const Color warnaUtama = Color(0xFF1E3A8A);
const Color warnaTulisan = Color(0xFF0F172A);
const Color warnaAbu = Color(0xFF64748B);
const Color warnaGaris = Color(0xFFE2E8F0);
const Color warnaLatar = Color(0xFFF1F5F9);

class ItemBarang {
  int id;
  String kode;
  String nama;
  String kategori;
  String lokasi;
  String lab;
  int stok;
  String kondisi;
  String deskripsi;
  String gambar;
  Uint8List? gambarBytes;

  ItemBarang({
    required this.id,
    required this.kode,
    required this.nama,
    required this.kategori,
    required this.lokasi,
    required this.lab,
    required this.stok,
    required this.kondisi,
    this.deskripsi = '',
    this.gambar = '',
    this.gambarBytes,
  });
}

const List<String> daftarKategori = [
  'Elektronik',
  'Jaringan',
  'Mikrokontroler',
  'Sensor',
];
const List<String> daftarLokasi = ['Gudang', 'Rak A', 'Rak B', 'Rak C'];
const List<String> daftarLab = ['Laboratorium Informatika'];
const List<String> daftarKondisi = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

final List<ItemBarang> dataBarang = [
  ItemBarang(
    id: 7,
    kode: 'BRG-007',
    nama: 'Kabel LAN UTP',
    kategori: 'Jaringan',
    lokasi: 'Gudang',
    lab: 'Laboratorium Informatika',
    stok: 40,
    kondisi: 'Baik',
    deskripsi: 'Kabel jaringan siap pakai',
    gambar:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJDK2G8VNKW9sBDZdFumHKvXrlBGzhsyOHYhaBuPmWTw&s',
  ),
  ItemBarang(
    id: 6,
    kode: 'BRG-006',
    nama: 'Breadboard',
    kategori: 'Elektronik',
    lokasi: 'Rak A',
    lab: 'Laboratorium Informatika',
    stok: 0,
    kondisi: 'Rusak Ringan',
    deskripsi: 'Papan rangkaian tanpa solder',
    gambar:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdWopusAudpCifim0_d90m9jMW-l-iCaoXoZSz_-tpGFAj4_UCRTTwwRzR&s=10',
  ),
  ItemBarang(
    id: 5,
    kode: 'BRG-005',
    nama: 'Raspberry Pi Pico',
    kategori: 'Mikrokontroler',
    lokasi: 'Gudang',
    lab: 'Laboratorium Informatika',
    stok: 5,
    kondisi: 'Rusak Berat',
    deskripsi: 'Mini komputer untuk proyek IoT',
    gambar:
        'https://www.silverlineelectronics.in/cdn/shop/products/Raspberry-Pi-Pico-W_Raspberry-Pi-Boards-amp-Official-Accessories_51556_1.png?v=1656574153',
  ),
  ItemBarang(
    id: 4,
    kode: 'BRG-004',
    nama: 'DHT 11',
    kategori: 'Sensor',
    lokasi: 'Rak B',
    lab: 'Laboratorium Informatika',
    stok: 27,
    kondisi: 'Baik',
    deskripsi: 'Sensor untuk mendeteksi suhu',
    gambar:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWzhg5FQYeGG9WVjMkKAW-4WrAzhwm3HfdWdVjM9KUQQ&s=10',
  ),
  ItemBarang(
    id: 3,
    kode: 'BRG-003',
    nama: 'Sensor Ultrasonik',
    kategori: 'Sensor',
    lokasi: 'Rak A',
    lab: 'Laboratorium Informatika',
    stok: 9,
    kondisi: 'Rusak Ringan',
    deskripsi: 'Mengukur jarak dengan gelombang ultrasonik',
    gambar:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3_ZjDcznYcstRIYP8R9GNY_51Kee8RCmLMRmXM2bsqGulcxKnb7iLmsJm&s=10',
  ),
  ItemBarang(
    id: 2,
    kode: 'BRG-002',
    nama: 'ESP32',
    kategori: 'Mikrokontroler',
    lokasi: 'Rak C',
    lab: 'Laboratorium Informatika',
    stok: 15,
    kondisi: 'Baik',
    deskripsi: 'Mikrokontroler dengan WiFi dan Bluetooth',
    gambar:
        'https://m.media-amazon.com/images/I/61MDW+U+rvL._AC_UF1000,1000_QL80_.jpg',
  ),
  ItemBarang(
    id: 1,
    kode: 'BRG-001',
    nama: 'Arduino Uno',
    kategori: 'Mikrokontroler',
    lokasi: 'Rak A',
    lab: 'Laboratorium Informatika',
    stok: 20,
    kondisi: 'Rusak Berat',
    deskripsi: 'Papan mikrokontroler untuk praktikum dasar',
    gambar:
        'https://upload.wikimedia.org/wikipedia/commons/3/38/Arduino_Uno_-_R3.jpg?utm_source=id.wikipedia.org&utm_campaign=index&utm_content=original',
  ),
];

class Lencana extends StatelessWidget {
  final String teks;
  final Color fg;
  final Color bg;

  const Lencana(this.teks, this.fg, this.bg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        teks,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class GambarBarang extends StatelessWidget {
  final String url;
  final Uint8List? bytes;
  final double lebar;
  final double tinggi;
  final double radius;

  const GambarBarang({
    super.key,
    required this.url,
    this.bytes,
    required this.lebar,
    required this.tinggi,
    this.radius = 8,
  });

  Widget _ikon() {
    return Container(
      width: lebar,
      height: tinggi,
      color: warnaLatar,
      child: Icon(
        Icons.inventory_2_outlined,
        size: tinggi < 60 ? 20 : 52,
        color: const Color(0xFF94A3B8),
      ),
    );
  }

  Widget _isi() {
    if (bytes != null) {
      return Image.memory(
        bytes!,
        width: lebar,
        height: tinggi,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _ikon(),
      );
    }
    if (url.isEmpty) return _ikon();
    return Image.network(
      url,
      width: lebar,
      height: tinggi,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _ikon(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: lebar,
          height: tinggi,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _isi(),
    );
  }
}

Lencana lencanaKondisi(String kondisi) {
  if (kondisi == 'Baik') {
    return const Lencana('Baik', Color(0xFF15803D), Color(0xFFDCFCE7));
  } else if (kondisi == 'Rusak Ringan') {
    return const Lencana('Rusak Ringan', Color(0xFFA16207), Color(0xFFFEF9C3));
  }
  return const Lencana('Rusak Berat', Color(0xFFB91C1C), Color(0xFFFEE2E2));
}

Lencana lencanaStok(int stok) {
  if (stok <= 0) {
    return const Lencana('Stok Habis', Color(0xFFB91C1C), Color(0xFFFEE2E2));
  } else if (stok <= 5) {
    return const Lencana('Stok Minimum', Color(0xFFC2410C), Color(0xFFFFEDD5));
  } else if (stok <= 10) {
    return const Lencana('Hampir Habis', Color(0xFFA16207), Color(0xFFFEF9C3));
  }
  return const Lencana('Aman', Color(0xFF15803D), Color(0xFFDCFCE7));
}

double progresStok(int stok) {
  if (stok <= 0) return 0;
  if (stok <= 5) return 0.2;
  if (stok <= 10) return 0.45;
  return 0.7;
}

InputDecoration dekorasi(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: warnaAbu, fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: warnaGaris),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: warnaGaris),
    ),
  );
}

void showDetailBarang(BuildContext context, ItemBarang b) {
  final Lencana status = lencanaStok(b.stok);

  Widget sel(String label, String isi) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: warnaAbu, fontSize: 12)),
          const SizedBox(height: 2),
          Text(isi, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Detail Barang', style: TextStyle(fontSize: 20)),
          IconButton(
            onPressed: () => Navigator.pop(ctx),
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 14,
              children: [
                sel('Kode Barang', b.kode),
                sel('Nama Barang', b.nama),
                sel('Kategori', b.kategori),
                sel('Lokasi', b.lokasi),
                sel('Stok', '${b.stok}'),
                sel('Kondisi', b.kondisi),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(color: warnaAbu, fontSize: 12),
            ),
            Text(b.deskripsi.isEmpty ? 'Tidak ada deskripsi' : b.deskripsi),
            const SizedBox(height: 16),
            const Text(
              'Status Stok',
              style: TextStyle(color: warnaAbu, fontSize: 12),
            ),
            const SizedBox(height: 6),
            status,
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresStok(b.stok),
                minHeight: 8,
                color: status.fg,
                backgroundColor: warnaGaris,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class KartuFilter extends StatelessWidget {
  final TextEditingController cari;
  final String? kategori;
  final String? lokasi;
  final String? kondisi;
  final ValueChanged<String?> onKategori;
  final ValueChanged<String?> onLokasi;
  final ValueChanged<String?> onKondisi;
  final VoidCallback onFilter;
  final VoidCallback onReset;

  const KartuFilter({
    super.key,
    required this.cari,
    required this.kategori,
    required this.lokasi,
    required this.kondisi,
    required this.onKategori,
    required this.onLokasi,
    required this.onKondisi,
    required this.onFilter,
    required this.onReset,
  });

  Widget _label(String teks, {double atas = 12}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6, top: atas),
      child: Text(
        teks,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _dropdown(
    String semua,
    String? nilai,
    List<String> opsi,
    ValueChanged<String?> onChanged,
  ) {
    return InputDecorator(
      decoration: dekorasi(''),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: nilai,
          isExpanded: true,
          isDense: true,
          items: [
            DropdownMenuItem<String>(value: null, child: Text(semua)),
            ...opsi.map(
              (o) => DropdownMenuItem<String>(value: o, child: Text(o)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _kolom(String label, Widget isi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_label(label, atas: 0), isi],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget fCari = _kolom(
      'Cari Barang',
      TextField(
        controller: cari,
        decoration: dekorasi('Nama atau kode barang'),
      ),
    );
    final Widget fKategori = _kolom(
      'Kategori',
      _dropdown('Semua Kategori', kategori, daftarKategori, onKategori),
    );
    final Widget fLokasi = _kolom(
      'Lokasi',
      _dropdown('Semua Lokasi', lokasi, daftarLokasi, onLokasi),
    );
    final Widget fKondisi = _kolom(
      'Kondisi',
      _dropdown('Semua Kondisi', kondisi, daftarKondisi, onKondisi),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: warnaGaris),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth >= 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: fCari),
                    const SizedBox(width: 16),
                    Expanded(child: fKategori),
                    const SizedBox(width: 16),
                    Expanded(child: fLokasi),
                    const SizedBox(width: 16),
                    Expanded(child: fKondisi),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fCari,
                  const SizedBox(height: 12),
                  fKategori,
                  const SizedBox(height: 12),
                  fLokasi,
                  const SizedBox(height: 12),
                  fKondisi,
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: onFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaUtama,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: const Text('Filter'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: warnaTulisan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FormBarang extends StatefulWidget {
  final ItemBarang? barang;

  const FormBarang({super.key, this.barang});

  @override
  State<FormBarang> createState() => _FormBarangState();
}

class _FormBarangState extends State<FormBarang> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kode;
  late TextEditingController _nama;
  late TextEditingController _stok;
  late TextEditingController _deskripsi;
  String? _kategori;
  String? _lokasi;
  String? _lab;
  String _kondisi = 'Baik';
  String _linkLama = '';
  Uint8List? _bytes;
  String _namaFile = '';

  @override
  void initState() {
    super.initState();
    final b = widget.barang;
    _kode = TextEditingController(text: b?.kode ?? '');
    _nama = TextEditingController(text: b?.nama ?? '');
    _stok = TextEditingController(text: b == null ? '' : '${b.stok}');
    _deskripsi = TextEditingController(text: b?.deskripsi ?? '');
    _kategori = b?.kategori;
    _lokasi = b?.lokasi;
    _lab = b?.lab;
    _kondisi = b?.kondisi ?? 'Baik';
    _linkLama = b?.gambar ?? '';
    _bytes = b?.gambarBytes;
  }

  @override
  void dispose() {
    _kode.dispose();
    _nama.dispose();
    _stok.dispose();
    _deskripsi.dispose();
    super.dispose();
  }

  Future<void> _pilihFile() async {
    final hasil = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (hasil != null && hasil.files.single.bytes != null) {
      setState(() {
        _bytes = hasil.files.single.bytes;
        _namaFile = hasil.files.single.name;
      });
    }
  }

  Widget _field(String label, Widget isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          isi,
        ],
      ),
    );
  }

  Widget _dua(Widget a, Widget b) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 460) {
          return Column(children: [a, b]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: a),
            const SizedBox(width: 20),
            Expanded(child: b),
          ],
        );
      },
    );
  }

  Widget _dropdown(
    String? nilai,
    List<String> opsi,
    String pesan,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: nilai,
      isExpanded: true,
      decoration: dekorasi(''),
      items: opsi
          .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? pesan : null,
    );
  }

  String? _wajib(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        ItemBarang(
          id: widget.barang?.id ?? 0,
          kode: _kode.text.trim(),
          nama: _nama.text.trim(),
          kategori: _kategori!,
          lokasi: _lokasi!,
          lab: _lab!,
          stok: int.parse(_stok.text),
          kondisi: _kondisi,
          deskripsi: _deskripsi.text.trim(),
          gambar: _linkLama,
          gambarBytes: _bytes,
        ),
      );
    }
  }

  Widget _uploadGambar() {
    final bool adaGambar = _bytes != null || _linkLama.isNotEmpty;
    return InkWell(
      onTap: _pilihFile,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: warnaGaris),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                border: Border.all(color: const Color(0xFF767676)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(fontSize: 13, color: warnaTulisan),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _namaFile.isNotEmpty
                    ? _namaFile
                    : (adaGambar ? 'Gambar saat ini' : 'No file chosen'),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: warnaTulisan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool edit = widget.barang != null;
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    edit ? 'Edit Barang' : 'Tambah Barang Baru',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: warnaGaris),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _dua(
                        _field(
                          'Kode Barang',
                          TextFormField(
                            controller: _kode,
                            decoration: dekorasi('BRG-001'),
                            validator: _wajib,
                          ),
                        ),
                        _field(
                          'Nama Barang',
                          TextFormField(
                            controller: _nama,
                            decoration: dekorasi('Nama Barang'),
                            validator: _wajib,
                          ),
                        ),
                      ),
                      _dua(
                        _field(
                          'Kategori',
                          _dropdown(
                            _kategori,
                            daftarKategori,
                            'Pilih kategori',
                            (v) => setState(() => _kategori = v),
                          ),
                        ),
                        _field(
                          'Lokasi',
                          _dropdown(
                            _lokasi,
                            daftarLokasi,
                            'Pilih lokasi',
                            (v) => setState(() => _lokasi = v),
                          ),
                        ),
                      ),
                      _dua(
                        _field(
                          'Laboratorium',
                          _dropdown(
                            _lab,
                            daftarLab,
                            'Pilih laboratorium',
                            (v) => setState(() => _lab = v),
                          ),
                        ),
                        _field(
                          'Stok',
                          TextFormField(
                            controller: _stok,
                            keyboardType: TextInputType.number,
                            decoration: dekorasi('0'),
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n < 0) {
                                return 'Isi angka 0 atau lebih';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      _dua(
                        _field(
                          'Kondisi',
                          DropdownButtonFormField<String>(
                            value: _kondisi,
                            isExpanded: true,
                            decoration: dekorasi(''),
                            items: daftarKondisi
                                .map(
                                  (o) => DropdownMenuItem<String>(
                                    value: o,
                                    child: Text(o),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _kondisi = v ?? 'Baik'),
                          ),
                        ),
                        _field('Upload Gambar', _uploadGambar()),
                      ),
                      _field(
                        'Keterangan',
                        TextFormField(
                          controller: _deskripsi,
                          maxLines: 4,
                          decoration: dekorasi('Keterangan tambahan...'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, color: warnaGaris),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: warnaTulisan,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warnaUtama,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Barang extends StatefulWidget {
  const Barang({super.key});

  @override
  State<Barang> createState() => _BarangState();
}

class _BarangState extends State<Barang> {
  final TextEditingController _cari = TextEditingController();
  String? _kategori;
  String? _lokasi;
  String? _kondisi;

  String _fCari = '';
  String? _fKategori;
  String? _fLokasi;
  String? _fKondisi;

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  List<ItemBarang> get _hasil {
    final String q = _fCari.toLowerCase();
    return dataBarang.where((b) {
      final cocokCari =
          q.isEmpty ||
          b.nama.toLowerCase().contains(q) ||
          b.kode.toLowerCase().contains(q);
      final cocokKategori = _fKategori == null || b.kategori == _fKategori;
      final cocokLokasi = _fLokasi == null || b.lokasi == _fLokasi;
      final cocokKondisi = _fKondisi == null || b.kondisi == _fKondisi;
      return cocokCari && cocokKategori && cocokLokasi && cocokKondisi;
    }).toList();
  }

  void _terapkanFilter() {
    setState(() {
      _fCari = _cari.text.trim();
      _fKategori = _kategori;
      _fLokasi = _lokasi;
      _fKondisi = _kondisi;
    });
  }

  void _resetFilter() {
    setState(() {
      _cari.clear();
      _kategori = null;
      _lokasi = null;
      _kondisi = null;
      _fCari = '';
      _fKategori = null;
      _fLokasi = null;
      _fKondisi = null;
    });
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  Future<void> _tambah() async {
    final ItemBarang? hasil = await showDialog<ItemBarang>(
      context: context,
      builder: (_) => const FormBarang(),
    );
    if (hasil != null && mounted) {
      setState(() {
        hasil.id = DateTime.now().millisecondsSinceEpoch;
        dataBarang.insert(0, hasil);
      });
      _pesan('Barang berhasil ditambahkan');
    }
  }

  Future<void> _edit(ItemBarang lama) async {
    final ItemBarang? hasil = await showDialog<ItemBarang>(
      context: context,
      builder: (_) => FormBarang(barang: lama),
    );
    if (hasil != null && mounted) {
      setState(() {
        final int i = dataBarang.indexWhere((b) => b.id == lama.id);
        if (i != -1) dataBarang[i] = hasil;
      });
      _pesan('Barang berhasil diperbarui');
    }
  }

  void _konfirmasiHapus(ItemBarang b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Konfirmasi Hapus', style: TextStyle(fontSize: 20)),
        content: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Apakah Anda yakin ingin menghapus barang '),
              TextSpan(
                text: b.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' ? Tindakan ini tidak dapat dibatalkan.'),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => dataBarang.removeWhere((x) => x.id == b.id));
              _pesan('Barang berhasil dihapus');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  DataRow _baris(ItemBarang b) {
    return DataRow(
      cells: [
        DataCell(
          Text(b.kode, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        DataCell(
          Row(
            children: [
              GambarBarang(
                url: b.gambar,
                bytes: b.gambarBytes,
                lebar: 44,
                tinggi: 44,
                radius: 8,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.nama,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    b.lab,
                    style: const TextStyle(fontSize: 11, color: warnaAbu),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(b.kategori)),
        DataCell(Text(b.lokasi)),
        DataCell(
          Text(
            '${b.stok}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const DataCell(Text('Unit')),
        DataCell(lencanaKondisi(b.kondisi)),
        DataCell(lencanaStok(b.stok)),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => showDetailBarang(context, b),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                color: const Color(0xFF2563EB),
              ),
              IconButton(
                onPressed: () => _edit(b),
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: const Color(0xFF16A34A),
              ),
              IconButton(
                onPressed: () => _konfirmasiHapus(b),
                icon: const Icon(Icons.delete_outline, size: 18),
                color: const Color(0xFFDC2626),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemBarang> hasil = _hasil;

    return Scaffold(
      backgroundColor: warnaLatar,
      appBar: CustomAppBar(),
      drawer: MyDrawer(currentroute: 'barang.dart'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Barang Laboratorium',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: warnaTulisan,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kelola seluruh inventaris barang laboratorium',
                        style: TextStyle(fontSize: 13, color: warnaAbu),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _tambah,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Barang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warnaUtama,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            KartuFilter(
              cari: _cari,
              kategori: _kategori,
              lokasi: _lokasi,
              kondisi: _kondisi,
              onKategori: (v) => setState(() => _kategori = v),
              onLokasi: (v) => setState(() => _lokasi = v),
              onKondisi: (v) => setState(() => _kondisi = v),
              onFilter: _terapkanFilter,
              onReset: _resetFilter,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: warnaGaris),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daftar Barang',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: warnaAbu,
                            ),
                            children: [
                              const TextSpan(text: 'Total: '),
                              TextSpan(
                                text: '${hasil.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' Barang'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: warnaGaris),
                  if (hasil.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tidak ada data barang ditemukan.',
                              style: TextStyle(color: warnaAbu),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowMinHeight: 64,
                        dataRowMaxHeight: 72,
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Kode')),
                          DataColumn(label: Text('Nama Barang')),
                          DataColumn(label: Text('Kategori')),
                          DataColumn(label: Text('Lokasi')),
                          DataColumn(label: Text('Stok')),
                          DataColumn(label: Text('Satuan')),
                          DataColumn(label: Text('Kondisi')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: hasil.map(_baris).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
