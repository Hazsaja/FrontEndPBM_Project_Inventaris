import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';


/// Peminjaman Barang (Admin, mobile): validasi permintaan.
class AdminPeminjamanPage extends StatefulWidget {
  const AdminPeminjamanPage({super.key});

  @override
  State<AdminPeminjamanPage> createState() => _AdminPeminjamanPageState();
}

class _AdminPeminjamanPageState extends State<AdminPeminjamanPage> {
  final PeminjamanRepository _repo = PeminjamanRepository.instance;
  int _tab = 0;

  bool _cocok(Peminjaman p) => switch (_tab) {
        0 => true,
        1 => p.status == StatusPinjam.menunggu,
        _ => p.status == StatusPinjam.dipinjam ||
            p.status == StatusPinjam.menungguKembali,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'admin_peminjaman.dart'),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final data = _repo.semua.where(_cocok).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Permintaan Barang',
                subjudul: 'Kelola permintaan peminjaman barang laboratorium',
              ),
              FilterTabs(
                labels: const ['Semua Permintaan', 'Pending', 'Disetujui'],
                terpilih: _tab,
                onPilih: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 14),
              if (data.isEmpty)
                const KosongState('Tidak ada data.')
              else
                for (final p in data)
                  PeminjamanCard(
                    item: p,
                    untukAdmin: true,
                    aksi: [
                      AksiTombol(
                          label: 'Detail',
                          onPressed: () =>
                              tampilkanDetail(context, p, untukAdmin: true)),
                      if (p.status == StatusPinjam.menunggu)
                        AksiTombol(
                            label: 'Validasi',
                            utama: true,
                            onPressed: () => validasiPeminjaman(context, p)),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }
}
