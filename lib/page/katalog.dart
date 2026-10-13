import 'package:flutter/material.dart';
import '../sidennavbar/customAppBar.dart';
import 'barang.dart';

class MyDrawerMahasiswa extends StatelessWidget {
  final String currentroute;

  const MyDrawerMahasiswa({super.key, this.currentroute = 'katalog.dart'});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1E293B);
    const activeColor = Color(0xFF3B82F6);
    const borderColor = Color(0xFF1E40AF);
    const subtextColor = Color(0xFFBFDBFE);

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lab Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Student Portal',
                        style: TextStyle(color: subtextColor, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    route: 'dashboardmahasiswa.dart',
                    activeColor: activeColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.inventory_2_outlined,
                    label: 'Katalog Barang',
                    route: 'katalog.dart',
                    activeColor: activeColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    label: 'Peminjaman Barang',
                    route: 'peminjaman.dart',
                    activeColor: activeColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.rotate_left,
                    label: 'Pengembalian Barang',
                    route: 'pengembalian.dart',
                    activeColor: activeColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.history,
                    label: 'Riwayat Peminjaman',
                    route: 'riwayat.dart',
                    activeColor: activeColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_outline,
                    label: 'Profil Saya',
                    route: 'profil.dart',
                    activeColor: activeColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading:
                    const Icon(Icons.logout, color: Colors.white, size: 20),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('login.dart');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required Color activeColor,
  }) {
    final bool isActive = currentroute == route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        selected: isActive,
        selectedTileColor: activeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(icon, color: Colors.white, size: 18),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (!isActive) {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(route);
          }
        },
      ),
    );
  }
}

class Katalog extends StatefulWidget {
  const Katalog({super.key});

  @override
  State<Katalog> createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
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
      final cocokCari = q.isEmpty ||
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

  Future<void> _pinjam(ItemBarang b) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (_) => PinjamDialog(barang: b),
    );
    if (ok == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan peminjaman dikirim')),
      );
    }
  }

  Widget _kartu(ItemBarang b) {
    final bool habis = b.stok <= 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: warnaGaris),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GambarBarang(
            url: b.gambar,
            lebar: double.infinity,
            tinggi: 120,
            radius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Lencana(b.kategori, const Color(0xFF1D4ED8),
                        const Color(0xFFDBEAFE)),
                    const SizedBox(width: 8),
                    Text(b.lokasi,
                        style: const TextStyle(fontSize: 12, color: warnaAbu)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  b.nama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: warnaTulisan,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  b.deskripsi.isEmpty ? 'Tidak ada deskripsi' : b.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: warnaAbu),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Stok',
                        style: TextStyle(fontSize: 12, color: warnaAbu)),
                    habis
                        ? const Lencana(
                            'Habis', Color(0xFFB91C1C), Color(0xFFFEE2E2))
                        : Lencana('${b.stok} tersedia', const Color(0xFF15803D),
                            const Color(0xFFDCFCE7)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kondisi',
                        style: TextStyle(fontSize: 12, color: warnaAbu)),
                    Text(
                      b.kondisi,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: lencanaKondisi(b.kondisi).fg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => showDetailBarang(context, b),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: warnaTulisan,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 38),
                        ),
                        child: const Text('Lihat Detail',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: habis ? null : () => _pinjam(b),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warnaUtama,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 38),
                        ),
                        child: const Text('Pinjam',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemBarang> hasil = _hasil;

    return Scaffold(
      backgroundColor: warnaLatar,
      appBar: CustomAppBar(
        userName: 'Mahasiswa Demo',
        userRole: 'Mahasiswa',
        userInitials: 'MA',
      ),
      drawer: MyDrawerMahasiswa(currentroute: 'katalog.dart'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Katalog Barang',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: warnaTulisan,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Jelajahi dan pinjam barang laboratorium yang tersedia',
              style: TextStyle(fontSize: 13, color: warnaAbu),
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
            if (hasil.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: warnaGaris),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inventory_outlined,
                        size: 48, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text('Barang Tidak Ditemukan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Tidak ada barang yang sesuai dengan pencarian.',
                        style: TextStyle(fontSize: 13, color: warnaAbu)),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  mainAxisExtent: 390,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: hasil.length,
                itemBuilder: (context, index) => _kartu(hasil[index]),
              ),
          ],
        ),
      ),
    );
  }
}

class PinjamDialog extends StatefulWidget {
  final ItemBarang barang;

  const PinjamDialog({super.key, required this.barang});

  @override
  State<PinjamDialog> createState() => _PinjamDialogState();
}

class _PinjamDialogState extends State<PinjamDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlah = TextEditingController(text: '1');
  final TextEditingController _keperluan = TextEditingController();
  final TextEditingController _tglPinjam = TextEditingController();
  final TextEditingController _tglKembali = TextEditingController();
  DateTime? _pinjam;
  DateTime? _kembali;

  @override
  void dispose() {
    _jumlah.dispose();
    _keperluan.dispose();
    _tglPinjam.dispose();
    _tglKembali.dispose();
    super.dispose();
  }

  String _format(DateTime d) {
    final String hari = d.day.toString().padLeft(2, '0');
    final String bulan = d.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${d.year}';
  }

  Future<void> _pilihTanggal(bool untukPinjam) async {
    final DateTime sekarang = DateTime.now();
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: sekarang,
      firstDate: sekarang,
      lastDate: sekarang.add(const Duration(days: 365)),
    );
    if (d != null) {
      setState(() {
        if (untukPinjam) {
          _pinjam = d;
          _tglPinjam.text = _format(d);
        } else {
          _kembali = d;
          _tglKembali.text = _format(d);
        }
      });
    }
  }

  Widget _field(String label, Widget isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          isi,
        ],
      ),
    );
  }

  String? _wajib(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Ajukan Peminjaman', style: TextStyle(fontSize: 20)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(
                  'Nama Barang',
                  TextFormField(
                    initialValue: widget.barang.nama,
                    readOnly: true,
                    decoration: dekorasi('').copyWith(
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                _field(
                  'Jumlah Pinjam',
                  TextFormField(
                    controller: _jumlah,
                    keyboardType: TextInputType.number,
                    decoration: dekorasi(''),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 1) return 'Minimal 1';
                      if (n > widget.barang.stok) return 'Melebihi stok';
                      return null;
                    },
                  ),
                ),
                _field(
                  'Keperluan',
                  TextFormField(
                    controller: _keperluan,
                    maxLines: 3,
                    decoration: dekorasi(''),
                    validator: _wajib,
                  ),
                ),
                _field(
                  'Tanggal Pinjam',
                  TextFormField(
                    controller: _tglPinjam,
                    readOnly: true,
                    onTap: () => _pilihTanggal(true),
                    decoration: dekorasi('dd/mm/yyyy').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    ),
                    validator: _wajib,
                  ),
                ),
                _field(
                  'Estimasi Kembali',
                  TextFormField(
                    controller: _tglKembali,
                    readOnly: true,
                    onTap: () => _pilihTanggal(false),
                    decoration: dekorasi('dd/mm/yyyy').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                      if (_pinjam != null &&
                          _kembali != null &&
                          _kembali!.isBefore(_pinjam!)) {
                        return 'Tidak boleh sebelum tanggal pinjam';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: warnaUtama,
            foregroundColor: Colors.white,
          ),
          child: const Text('Ajukan'),
        ),
      ],
    );
  }
}
