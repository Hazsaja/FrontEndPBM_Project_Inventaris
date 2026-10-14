import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';

import 'package:inventaris_v_pbm/page/barang.dart' show dataBarang;

/// Dashboard Admin (mobile).
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PeminjamanRepository.instance;
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'main.dart'),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final semua = repo.semua;
          List<Peminjaman> dengan(StatusPinjam s) =>
              semua.where((p) => p.status == s).toList();
          final menunggu = dengan(StatusPinjam.menunggu);
          final dipinjam = dengan(StatusPinjam.dipinjam);
          final kembali = dengan(StatusPinjam.menungguKembali);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Dashboard',
                subjudul: 'Ringkasan sistem inventaris laboratorium',
              ),
              duaKolom(
                StatCard(
                    title: 'Total Barang',
                    value: '${dataBarang.length}',
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF3B82F6)),
                StatCard(
                    title: 'Permintaan Menunggu',
                    value: '${menunggu.length}',
                    icon: Icons.schedule,
                    color: const Color(0xFFEAB308)),
              ),
              const SizedBox(height: 12),
              duaKolom(
                StatCard(
                    title: 'Sedang Dipinjam',
                    value: '${dipinjam.length + kembali.length}',
                    icon: Icons.assignment_turned_in_outlined,
                    color: const Color(0xFFEF4444)),
                StatCard(
                    title: 'Menunggu Pengembalian',
                    value: '${kembali.length}',
                    icon: Icons.rotate_left,
                    color: const Color(0xFFF97316)),
              ),
              JudulBagian('Permintaan Terbaru',
                  aksi: 'Lihat Semua',
                  onAksi: () =>
                      Navigator.of(context).pushNamed('admin_peminjaman.dart')),
              if (menunggu.isEmpty)
                const KosongState('Tidak ada permintaan baru.')
              else
                for (final p in menunggu.take(3))
                  PeminjamanCard(
                    item: p,
                    untukAdmin: true,
                    aksi: [
                      AksiTombol(
                          label: 'Validasi',
                          utama: true,
                          onPressed: () => validasiPeminjaman(context, p)),
                    ],
                  ),
              JudulBagian('Pengembalian Terbaru',
                  aksi: 'Lihat Semua',
                  onAksi: () => Navigator.of(context)
                      .pushNamed('admin_pengembalian.dart')),
              if (kembali.isEmpty)
                const KosongState('Tidak ada pengembalian menunggu.')
              else
                for (final p in kembali.take(3))
                  PeminjamanCard(
                    item: p,
                    untukAdmin: true,
                    aksi: [
                      AksiTombol(
                          label: 'Verifikasi',
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
