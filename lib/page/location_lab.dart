import 'package:flutter/material.dart';
// === [TAMBAHAN] Import relatif komponen navbar & sidebar ===
import '../sidennavbar/customAppBar.dart';
import '../sidennavbar/sidebar.dart';

// === [HAPUS] Fungsi main() & MaterialApp duplikat dibuang dari file ini ===

class LocationModel {
  final int id;
  String namaLokasi;
  String keterangan;
  int jumlahBarang;

  LocationModel({
    required this.id,
    required this.namaLokasi,
    required this.keterangan,
    this.jumlahBarang = 0,
  });

  LocationModel copyWith({
    int? id,
    String? namaLokasi,
    String? keterangan,
    int? jumlahBarang,
  }) {
    return LocationModel(
      id: id ?? this.id,
      namaLokasi: namaLokasi ?? this.namaLokasi,
      keterangan: keterangan ?? this.keterangan,
      jumlahBarang: jumlahBarang ?? this.jumlahBarang,
    );
  }
}

class LocationLab extends StatefulWidget {
  const LocationLab({super.key});

  @override
  State<LocationLab> createState() => _LocationLabState();
}

class _LocationLabState extends State<LocationLab> {
  final List<LocationModel> _locations = [
    LocationModel(
      id: 1,
      namaLokasi: 'Rak A1 - Alat Kimia',
      keterangan: 'Penyimpanan tabung reaksi, beker, dan alat kaca ringan',
      jumlahBarang: 14,
    ),
    LocationModel(
      id: 2,
      namaLokasi: 'Lemari B2 - Reagen',
      keterangan: 'Bahan kimia cair dan padat bertemperatur kamar',
      jumlahBarang: 8,
    ),
    LocationModel(
      id: 3,
      namaLokasi: 'Gudang C - Mikroskop',
      keterangan: 'Penyimpanan mikroskop optik dan perangkat digital',
      jumlahBarang: 25,
    ),
    LocationModel(
      id: 4,
      namaLokasi: 'Meja Praktikum Utama',
      keterangan: 'Area penyimpanan alat yang sering digunakan harian',
      jumlahBarang: 5,
    ),
  ];

  String _searchQuery = '';

  List<LocationModel> get _filteredLocations {
    if (_searchQuery.isEmpty) return _locations;
    return _locations.where((loc) {
      final nameMatch =
          loc.namaLokasi.toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch =
          loc.keterangan.toLowerCase().contains(_searchQuery.toLowerCase());
      return nameMatch || descMatch;
    }).toList();
  }

  void _addLocation(String nama, String keterangan) {
    final newId = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _locations.add(
        LocationModel(
          id: newId,
          namaLokasi: nama,
          keterangan: keterangan,
          jumlahBarang: 0,
        ),
      );
    });
    _showSnackBar('Lokasi "$nama" berhasil ditambahkan!', Colors.green);
  }

  void _updateLocation(int id, String nama, String keterangan) {
    setState(() {
      final index = _locations.indexWhere((element) => element.id == id);
      if (index != -1) {
        _locations[index].namaLokasi = nama;
        _locations[index].keterangan = keterangan;
      }
    });
    _showSnackBar('Data lokasi berhasil diperbarui!', Colors.blue);
  }

  void _deleteLocation(int id) {
    final target = _locations.firstWhere((e) => e.id == id);
    setState(() {
      _locations.removeWhere((element) => element.id == id);
    });
    _showSnackBar('Lokasi "${target.namaLokasi}" telah dihapus', Colors.red);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _openTambahDialog() {
    final namaController = TextEditingController();
    final ketController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Tambah Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: SizedBox(
          width: 450,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nama Lokasi',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: namaController,
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? 'Nama lokasi wajib diisi'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Rak A1 - Alat Kimia',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Keterangan',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ketController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi singkat lokasi penyimpanan...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _addLocation(namaController.text, ketController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(LocationModel location) {
    final namaController = TextEditingController(text: location.namaLokasi);
    final ketController = TextEditingController(text: location.keterangan);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: SizedBox(
          width: 450,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nama Lokasi',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: namaController,
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? 'Nama lokasi tidak boleh kosong'
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Keterangan',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ketController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _updateLocation(
                    location.id, namaController.text, ketController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openHapusDialog(LocationModel location) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Lokasi',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: 'Poppins'),
                  children: [
                    const TextSpan(
                        text: 'Apakah Anda yakin ingin menghapus lokasi '),
                    TextSpan(
                      text: location.namaLokasi,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Data yang dihapus tidak dapat dikembalikan.',
                style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              _deleteLocation(location.id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === [PERUBAHAN] Menggunakan CustomAppBar dan MyDrawer bawaan proyek ===
      appBar: const CustomAppBar(),
      drawer: const MyDrawer(currentroute: 'location_lab.dart'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitleSection(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildLocationGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitleSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        return Flex(
          direction: isSmall ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              isSmall ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lokasi Penyimpanan',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola lokasi penyimpanan barang laboratorium (${_filteredLocations.length} lokasi)',
                  style:
                      const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                ),
              ],
            ),
            if (isSmall) const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openTambahDialog,
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text('Tambah Lokasi',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: TextField(
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Cari nama lokasi atau keterangan...',
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildLocationGrid() {
    if (_filteredLocations.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: const [
            Icon(Icons.location_off_outlined,
                size: 60, color: Color(0xFF94A3B8)),
            SizedBox(height: 12),
            Text(
              'Tidak ada lokasi ditemukan',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF475569)),
            ),
            SizedBox(height: 4),
            Text('Coba kata kunci lain atau tambah lokasi baru.',
                style: TextStyle(color: Color(0xFF94A3B8))),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 1100) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 650) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            mainAxisExtent: 190,
          ),
          itemCount: _filteredLocations.length,
          itemBuilder: (context, index) {
            final loc = _filteredLocations[index];
            return _buildLocationCard(loc);
          },
        );
      },
    );
  }

  Widget _buildLocationCard(LocationModel location) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, color: Color(0xFF1E3A8A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.namaLokasi,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.keterangan.isNotEmpty
                          ? location.keterangan
                          : 'Tidak ada keterangan',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${location.jumlahBarang} Barang',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: Color(0xFF16A34A), size: 20),
                    onPressed: () => _openEditDialog(location),
                    tooltip: 'Edit Lokasi',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFDC2626), size: 20),
                    onPressed: () => _openHapusDialog(location),
                    tooltip: 'Hapus Lokasi',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// === [HAPUS] Class SidebarNavigation internal telah dihapus ===