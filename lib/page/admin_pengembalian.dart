import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';


/// Pengembalian Barang (Admin, mobile): verifikasi pengembalian.
class AdminPengembalianPage extends StatefulWidget {
  const AdminPengembalianPage({super.key});

  @override
  State<AdminPengembalianPage> createState() => _AdminPengembalianPageState();
}

class _AdminPengembalianPageState extends State<AdminPengembalianPage> {
  final PeminjamanRepository _repo = PeminjamanRepository.instance;
  int _tab = 0;

  static const _tampil = [
    StatusPinjam.dipinjam,
    StatusPinjam.menungguKembali,
    StatusPinjam.selesai,
  ];

  bool _cocok(Peminjaman p) {
    if (!_tampil.contains(p.status)) return false;
    return switch (_tab) {
      0 => true,
      1 => p.status == StatusPinjam.dipinjam,
      2 => p.status == StatusPinjam.menungguKembali,
      _ => p.status == StatusPinjam.selesai,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'admin_pengembalian.dart'),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final data = _repo.semua.where(_cocok).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Pengembalian Barang',
                subjudul: 'Kelola pengembalian barang laboratorium',
              ),
              FilterTabs(
                labels: const [
                  'Semua Data',
                  'Sedang Dipinjam',
                  'Menunggu Persetujuan',
                  'Sudah Kembali',
                ],
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
                      if (p.status == StatusPinjam.menungguKembali)
                        AksiTombol(
                            label: 'Proses',
                            utama: true,
                            onPressed: () => prosesPengembalian(context, p)),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }
}
