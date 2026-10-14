import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';

/// Riwayat Peminjaman Mahasiswa/Laboran (mobile).
class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final PeminjamanRepository _repo = PeminjamanRepository.instance;
  int _tab = 0;

  bool _cocok(Peminjaman p) => switch (_tab) {
        0 => true,
        1 => p.status == StatusPinjam.menunggu,
        2 => p.status == StatusPinjam.dipinjam ||
            p.status == StatusPinjam.menungguKembali,
        3 => p.status == StatusPinjam.selesai,
        _ => p.status == StatusPinjam.ditolak,
      };

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'riwayat.dart'),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final data = _repo.milik(user?.id ?? '').where(_cocok).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Riwayat Peminjaman',
                subjudul:
                    'Pantau status seluruh pengajuan peminjaman barang Anda',
              ),
              FilterTabs(
                labels: const [
                  'Semua',
                  'Menunggu',
                  'Dipinjam',
                  'Selesai',
                  'Ditolak',
                ],
                terpilih: _tab,
                onPilih: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 14),
              if (data.isEmpty)
                const KosongState(
                    'Belum ada riwayat aktivitas peminjaman barang.',
                    icon: Icons.history)
              else
                for (final p in data)
                  PeminjamanCard(
                    item: p,
                    aksi: [
                      AksiTombol(
                          label: 'Detail',
                          onPressed: () => tampilkanDetail(context, p)),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }
}
