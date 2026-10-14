import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';


/// Permintaan/Peminjaman Barang untuk Mahasiswa/Laboran (mobile).
class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final PeminjamanRepository _repo = PeminjamanRepository.instance;
  int _tab = 0;

  bool _cocok(Peminjaman p) => switch (_tab) {
        0 => true,
        1 => p.status == StatusPinjam.menunggu,
        _ => p.status == StatusPinjam.dipinjam ||
            p.status == StatusPinjam.menungguKembali,
      };

  Future<void> _batal(Peminjaman p) async {
    final ok = await konfirmasi(context,
        judul: 'Batalkan permintaan',
        pesan: 'Batalkan permintaan peminjaman ${p.barang}?',
        ya: 'Ya, batalkan',
        bahaya: true);
    if (!ok || !mounted) return;
    _repo.batalkan(p.id);
    tampilkanSnack(context, 'Permintaan dibatalkan');
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'peminjaman.dart'),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final data = _repo.milik(user?.id ?? '').where(_cocok).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Permintaan Barang',
                subjudul: 'Pantau permintaan peminjaman barang laboratorium',
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
                    aksi: [
                      AksiTombol(
                          label: 'Detail',
                          onPressed: () => tampilkanDetail(context, p)),
                      if (p.status == StatusPinjam.menunggu)
                        AksiTombol(
                            label: 'Batal',
                            bahaya: true,
                            onPressed: () => _batal(p)),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }
}
