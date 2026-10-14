import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';

import 'package:inventaris_v_pbm/page/barang.dart' show dataBarang;

/// Dashboard Mahasiswa/Laboran (mobile).
class DashboardUserPage extends StatelessWidget {
  const DashboardUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final repo = PeminjamanRepository.instance;
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'dashboard_user.dart'),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final milik = repo.milik(user?.id ?? '');
          int hitung(bool Function(Peminjaman) f) => milik.where(f).length;
          final menunggu = hitung((p) => p.status == StatusPinjam.menunggu);
          final dipinjam = hitung((p) =>
              p.status == StatusPinjam.dipinjam ||
              p.status == StatusPinjam.menungguKembali);
          final selesai = hitung((p) => p.status == StatusPinjam.selesai);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              JudulHalaman(
                judul: 'Selamat datang, ${user?.nama ?? ''}',
                subjudul: 'Ringkasan peminjaman Anda',
              ),
              duaKolom(
                StatCard(
                    title: 'Permintaan Menunggu',
                    value: '$menunggu',
                    icon: Icons.schedule,
                    color: const Color(0xFFEAB308)),
                StatCard(
                    title: 'Barang Dipinjam',
                    value: '$dipinjam',
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF3B82F6)),
              ),
              const SizedBox(height: 12),
              StatCard(
                  title: 'Riwayat Selesai',
                  value: '$selesai',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF22C55E)),
              JudulBagian('Barang Terbaru',
                  aksi: 'Lihat Katalog',
                  onAksi: () => Navigator.of(context).pushNamed('katalog.dart')),
              for (final b in dataBarang.take(3))
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.nama,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kTextDark)),
                            const SizedBox(height: 2),
                            Text('${b.kategori} · ${b.lokasi} · ${b.kondisi}',
                                style: const TextStyle(
                                    fontSize: 12.5, color: kTextMuted)),
                            const SizedBox(height: 6),
                            Text(
                              b.stok > 0 ? '${b.stok} tersedia' : 'Stok habis',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: b.stok > 0
                                      ? const Color(0xFF047857)
                                      : kErrorRed),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: b.stok > 0
                            ? () => Navigator.of(context).pushNamed('katalog.dart')
                            : null,
                        style: FilledButton.styleFrom(
                            backgroundColor: kBiruTua,
                            minimumSize: const Size(64, 44)),
                        child: const Text('Pinjam'),
                      ),
                    ],
                  ),
                ),
              JudulBagian('Riwayat Peminjaman Terakhir',
                  aksi: 'Lihat Semua',
                  onAksi: () => Navigator.of(context).pushNamed('peminjaman.dart')),
              if (milik.isEmpty)
                const KosongState('Belum ada riwayat peminjaman.')
              else
                for (final p in milik.take(3)) PeminjamanCard(item: p),
            ],
          );
        },
      ),
    );
  }
}
