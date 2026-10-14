import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';


/// Pengembalian Barang untuk Mahasiswa/Laboran (mobile).
class PengembalianPage extends StatelessWidget {
  const PengembalianPage({super.key});

  Future<void> _kembalikan(BuildContext context, Peminjaman p) async {
    final ok = await konfirmasi(context,
        judul: 'Ajukan pengembalian',
        pesan: 'Ajukan pengembalian untuk barang ini?',
        ya: 'Ajukan');
    if (!ok || !context.mounted) return;
    PeminjamanRepository.instance.ajukanPengembalian(p.id);
    tampilkanSnack(context, 'Pengembalian diajukan, menunggu admin');
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final repo = PeminjamanRepository.instance;
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'pengembalian.dart'),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final data = repo
              .milik(user?.id ?? '')
              .where((p) =>
                  p.status == StatusPinjam.dipinjam ||
                  p.status == StatusPinjam.menungguKembali)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Pengembalian Barang',
                subjudul: 'Pilih barang yang ingin Anda kembalikan',
              ),
              if (data.isEmpty)
                const KosongState(
                    'Tidak ada barang yang sedang dipinjam.',
                    icon: Icons.inventory_2_outlined)
              else
                for (final p in data)
                  PeminjamanCard(
                    item: p,
                    aksi: [
                      if (p.status == StatusPinjam.dipinjam)
                        AksiTombol(
                            label: 'Kembalikan',
                            utama: true,
                            onPressed: () => _kembalikan(context, p)),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }
}
