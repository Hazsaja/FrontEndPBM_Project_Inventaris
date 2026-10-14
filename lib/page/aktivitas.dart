import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';
import 'package:inventaris_v_pbm/widgets/peminjaman_widgets.dart';

/// Riwayat Aktivitas (Admin, mobile): log peminjaman dan pengembalian.
class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  final PeminjamanRepository _repo = PeminjamanRepository.instance;
  int _tab = 0;

  bool _cocok(Aktivitas a) => switch (_tab) {
        0 => true,
        1 => a.jenis == JenisAktivitas.peminjaman,
        _ => a.jenis == JenisAktivitas.pengembalian,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLatar,
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'aktivitas.dart'),
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final data = _repo.aktivitas.where(_cocok).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const JudulHalaman(
                judul: 'Riwayat Aktivitas',
                subjudul: 'Log aktivitas peminjaman dan pengembalian barang',
              ),
              FilterTabs(
                labels: const ['Semua', 'Peminjaman', 'Pengembalian'],
                terpilih: _tab,
                onPilih: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 14),
              if (data.isEmpty)
                const KosongState('Belum ada aktivitas.', icon: Icons.history)
              else
                for (final a in data)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFE0E7FF),
                          child: Text(
                            a.pelaku.isEmpty ? '?' : a.pelaku[0].toUpperCase(),
                            style: const TextStyle(
                                color: kBiruTua, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                      fontSize: 13.5, color: kTextDark),
                                  children: [
                                    TextSpan(
                                        text: a.pelaku,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(text: ' ${a.teks}'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(waktuRelatif(a.waktu),
                                  style: const TextStyle(
                                      fontSize: 12, color: kTextMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
