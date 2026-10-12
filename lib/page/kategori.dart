import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/sidennavbar/customAppBar.dart';

import '../sidennavbar/sidebar.dart';
import '../model/kategori_model.dart';
import '../widgets/kategori_card.dart';
import 'kategori_form_dialog.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final TextEditingController searchController = TextEditingController();

  final List<Kategori> daftarKategori = [
    Kategori(
      nama: 'Alat Lab',
      deskripsi: 'Peralatan untuk kebutuhan laboratorium.',
    ),
    Kategori(
      nama: 'Glassware',
      deskripsi: 'Peralatan laboratorium berbahan kaca.',
    ),
    Kategori(
      nama: 'Elektronik',
      deskripsi: 'Peralatan elektronik laboratorium.',
    ),
    Kategori(
      nama: 'Peralatan Komputer',
      deskripsi: 'Perangkat komputer dan perlengkapannya.',
    ),
    Kategori(
      nama: 'Multimedia',
      deskripsi: 'Peralatan untuk kebutuhan multimedia.',
    ),
  ];

  final List<DataBarangInventaris> daftarBarang = [
    DataBarangInventaris(nama: 'Mikroskop', kategori: 'Alat Lab'),
    DataBarangInventaris(nama: 'Gelas Ukur', kategori: 'Glassware'),
    DataBarangInventaris(nama: 'Multimeter', kategori: 'Elektronik'),
    DataBarangInventaris(nama: 'Keyboard', kategori: 'Peralatan Komputer'),
    DataBarangInventaris(nama: 'Proyektor', kategori: 'Multimedia'),
    DataBarangInventaris(nama: 'Tabung Reaksi', kategori: 'Glassware'),
    DataBarangInventaris(nama: 'Laptop', kategori: 'Peralatan Komputer'),
    DataBarangInventaris(nama: 'Osiloskop', kategori: 'Elektronik'),
  ];

  String kataKunci = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Kategori> get kategoriTampil {
    final query = kataKunci.trim().toLowerCase();

    if (query.isEmpty) {
      return daftarKategori;
    }

    return daftarKategori.where((kategori) {
      return kategori.nama.toLowerCase().contains(query) ||
          kategori.deskripsi.toLowerCase().contains(query);
    }).toList();
  }

  int hitungBarang(String namaKategori) {
    return daftarBarang
        .where((barang) => barang.kategori == namaKategori)
        .length;
  }

  Future<void> tampilkanForm({Kategori? kategori}) async {
    // Simpan referensi kategori yang akan diedit.
    // Jika null, berarti pengguna sedang menambahkan kategori baru.
    final Kategori? kategoriEdit = kategori;

    final List<String> namaKategori = daftarKategori
        .where((item) => !identik(item, kategoriEdit))
        .map((item) => item.nama)
        .toList();

    final hasil = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return KategoriFormDialog(
          kategori: kategoriEdit,
          namaKategori: namaKategori,
        );
      },
    );

    if (!mounted || hasil == null) {
      return;
    }

    final String namaBaru = (hasil['nama'] ?? '').trim();
    final String deskripsiBaru = (hasil['deskripsi'] ?? '').trim();

    if (namaBaru.isEmpty || deskripsiBaru.isEmpty) {
      return;
    }

    setState(() {
      if (kategoriEdit != null) {
        // Perbarui kategori yang sudah ada.
        final String namaLama = kategoriEdit.nama;

        kategoriEdit.nama = namaBaru;
        kategoriEdit.deskripsi = deskripsiBaru;

        // Sesuaikan nama kategori pada barang yang sudah terhubung.
        for (final barang in daftarBarang) {
          if (barang.kategori == namaLama) {
            // DataBarangInventaris.kategori bersifat final,
            // jadi barang perlu diganti dengan objek baru.
            final index = daftarBarang.indexOf(barang);

            daftarBarang[index] = DataBarangInventaris(
              nama: barang.nama,
              kategori: namaBaru,
            );
          }
        }
      } else {
        // Tambahkan kategori baru.
        daftarKategori.add(Kategori(nama: namaBaru, deskripsi: deskripsiBaru));
      }
    });
  }

  bool identik(Kategori item, Kategori? kategoriEdit) {
    return kategoriEdit != null && identical(item, kategoriEdit);
  }

  void hapusKategori(Kategori kategori) {
    final int jumlahBarang = hitungBarang(kategori.nama);

    if (jumlahBarang > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kategori "${kategori.nama}" tidak dapat dihapus '
            'karena masih memiliki $jumlahBarang barang.',
          ),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Kategori'),
          content: Text(
            'Apakah kamu yakin ingin menghapus kategori '
            '"${kategori.nama}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  daftarKategori.remove(kategori);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kategori berhasil dihapus.')),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final List<Kategori> dataTampil = kategoriTampil;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const MyDrawer(currentroute: 'kategori.dart'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kategori Barang',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172554),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kelola kategori barang inventaris laboratorium.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Ringkasan kategori dan barang.
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool narrow = constraints.maxWidth < 500;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildSummaryCard(
                        title: 'Total Kategori',
                        value: daftarKategori.length.toString(),
                        icon: Icons.category_outlined,
                        color: const Color(0xFF2563EB),
                        width: narrow
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                      ),
                      _buildSummaryCard(
                        title: 'Total Barang',
                        value: daftarBarang.length.toString(),
                        icon: Icons.inventory_2_outlined,
                        color: const Color(0xFF16A34A),
                        width: narrow
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Pencarian dan tombol tambah.
              if (isMobile) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => tampilkanForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kategori'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSearchField(),
              ] else
                Row(
                  children: [
                    Expanded(child: _buildSearchField()),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => tampilkanForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Kategori'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // Daftar kategori.
              if (dataTampil.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        kataKunci.isEmpty
                            ? 'Belum ada kategori.'
                            : 'Kategori tidak ditemukan.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final int columns = constraints.maxWidth >= 1100
                        ? 3
                        : constraints.maxWidth >= 700
                            ? 2
                            : 1;

                    final double spacing = 16;
                    final double cardWidth =
                        (constraints.maxWidth - (spacing * (columns - 1))) /
                            columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: dataTampil.map((kategori) {
                        return SizedBox(
                          width: cardWidth,
                          child: KategoriCard(
                            kategori: kategori,
                            jumlahBarang: hitungBarang(kategori.nama),
                            isMobile: isMobile,
                            onEdit: () => tampilkanForm(kategori: kategori),
                            onDelete: () => hapusKategori(kategori),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          kataKunci = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari nama atau deskripsi kategori...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: kataKunci.isNotEmpty
            ? IconButton(
                tooltip: 'Hapus pencarian',
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    kataKunci = '';
                  });
                },
                icon: const Icon(Icons.close),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
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
