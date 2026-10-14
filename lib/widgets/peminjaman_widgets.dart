import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/data/peminjaman_repository.dart';

const Color kLatar = Color(0xFFF1F5F9);
const Color kBiruTua = Color(0xFF1E3A8A);

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.untukAdmin = false});

  final StatusPinjam status;
  final bool untukAdmin;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      StatusPinjam.menunggu =>
        ('Menunggu', const Color(0xFFFEF3C7), const Color(0xFFB45309)),
      StatusPinjam.dipinjam =>
        ('Dipinjam', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      StatusPinjam.menungguKembali => (
          untukAdmin ? 'Menunggu Persetujuan' : 'Menunggu Admin',
          const Color(0xFFFEF3C7),
          const Color(0xFFB45309)
        ),
      StatusPinjam.selesai =>
        ('Selesai', const Color(0xFFD1FAE5), const Color(0xFF047857)),
      StatusPinjam.ditolak =>
        ('Ditolak', const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 11.5, fontWeight: FontWeight.w600)),
    );
  }
}

BoxDecoration _kartu() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorder),
    );

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, color: kTextDark)),
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(fontSize: 12, color: kTextMuted)),
        ],
      ),
    );
  }
}

Widget duaKolom(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      ),
    );

class JudulHalaman extends StatelessWidget {
  const JudulHalaman({super.key, required this.judul, required this.subjudul});
  final String judul;
  final String subjudul;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(judul,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: kTextDark)),
            const SizedBox(height: 2),
            Text(subjudul,
                style: const TextStyle(fontSize: 13, color: kTextMuted)),
          ],
        ),
      );
}

class JudulBagian extends StatelessWidget {
  const JudulBagian(this.judul, {super.key, this.aksi, this.onAksi});
  final String judul;
  final String? aksi;
  final VoidCallback? onAksi;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(judul,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kTextDark)),
            ),
            if (aksi != null)
              TextButton(onPressed: onAksi, child: Text(aksi!)),
          ],
        ),
      );
}

class FilterTabs extends StatelessWidget {
  const FilterTabs(
      {super.key,
      required this.labels,
      required this.terpilih,
      required this.onPilih});
  final List<String> labels;
  final int terpilih;
  final ValueChanged<int> onPilih;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(labels[i]),
                  selected: terpilih == i,
                  onSelected: (_) => onPilih(i),
                  selectedColor: kBiruTua,
                  labelStyle: TextStyle(
                      color: terpilih == i ? Colors.white : kTextDark,
                      fontSize: 13),
                  checkmarkColor: Colors.white,
                ),
              ),
          ],
        ),
      );
}

class AksiTombol extends StatelessWidget {
  const AksiTombol(
      {super.key,
      required this.label,
      required this.onPressed,
      this.utama = false,
      this.bahaya = false});
  final String label;
  final VoidCallback onPressed;
  final bool utama;
  final bool bahaya;

  @override
  Widget build(BuildContext context) {
    if (utama) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
            backgroundColor: kBiruTua, minimumSize: const Size(0, 44)),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        foregroundColor: bahaya ? kErrorRed : kBiruTua,
        side: BorderSide(color: bahaya ? kErrorRed : kInputBorder),
      ),
      child: Text(label),
    );
  }
}

class PeminjamanCard extends StatelessWidget {
  const PeminjamanCard(
      {super.key,
      required this.item,
      this.untukAdmin = false,
      this.aksi = const []});
  final Peminjaman item;
  final bool untukAdmin;
  final List<Widget> aksi;

  @override
  Widget build(BuildContext context) {
    const muted = TextStyle(fontSize: 12.5, color: kTextMuted);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('${item.barang} · ${item.jumlah} pcs',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kTextDark)),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: item.status, untukAdmin: untukAdmin),
            ],
          ),
          if (untukAdmin) ...[
            const SizedBox(height: 4),
            Text('${item.peminjam} · ${item.npm}', style: muted),
          ],
          const SizedBox(height: 4),
          Text('Keperluan: ${item.keperluan}', style: muted),
          Text(
              '${formatTanggal(item.tglPinjam)} → ${formatTanggal(item.batasKembali)}',
              style: muted),
          if (aksi.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < aksi.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: aksi[i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class KosongState extends StatelessWidget {
  const KosongState(this.pesan, {super.key, this.icon = Icons.inbox_outlined});
  final String pesan;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(icon, size: 40, color: kTextMuted),
            const SizedBox(height: 10),
            Text(pesan,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kTextMuted)),
          ],
        ),
      );
}

Future<bool> konfirmasi(BuildContext context,
    {required String judul,
    required String pesan,
    String ya = 'Ya',
    bool bahaya = false}) async {
  final hasil = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(judul),
      content: Text(pesan),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: bahaya ? kErrorRed : kBiruTua),
          onPressed: () => Navigator.pop(c, true),
          child: Text(ya),
        ),
      ],
    ),
  );
  return hasil == true;
}

void tampilkanSnack(BuildContext context, String pesan) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
}

Widget _baris(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(k,
                  style: const TextStyle(fontSize: 13, color: kTextMuted))),
          Expanded(
              child: Text(v,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kTextDark))),
        ],
      ),
    );

List<Widget> _ringkasan(Peminjaman p) => [
      _baris('Peminjam', '${p.peminjam} (${p.npm})'),
      _baris('Barang', p.barang),
      _baris('Jumlah', '${p.jumlah}'),
      _baris('Keperluan', p.keperluan),
      _baris('Tanggal Pinjam', formatTanggal(p.tglPinjam)),
      _baris('Batas Kembali', formatTanggal(p.batasKembali)),
    ];

void tampilkanDetail(BuildContext context, Peminjaman p,
    {bool untukAdmin = false}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Peminjaman',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ..._ringkasan(p),
            _baris('Catatan Admin',
                p.catatanAdmin.isEmpty ? '-' : p.catatanAdmin),
            const SizedBox(height: 8),
            Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(status: p.status, untukAdmin: untukAdmin)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AksiTombol(
                  label: 'Tutup', onPressed: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CatatanSheet extends StatefulWidget {
  const _CatatanSheet({
    required this.judul,
    required this.item,
    required this.labelCatatan,
    required this.hint,
    required this.labelTolak,
    required this.labelSetuju,
    required this.onTolak,
    required this.onSetuju,
  });

  final String judul;
  final Peminjaman item;
  final String labelCatatan;
  final String hint;
  final String labelTolak;
  final String labelSetuju;
  final void Function(String) onTolak;
  final void Function(String) onSetuju;

  @override
  State<_CatatanSheet> createState() => _CatatanSheetState();
}

class _CatatanSheetState extends State<_CatatanSheet> {
  final TextEditingController _catatan = TextEditingController();

  @override
  void dispose() {
    _catatan.dispose();
    super.dispose();
  }

  void _kirim(void Function(String) aksi) {
    final teks = _catatan.text.trim();
    Navigator.pop(context);
    aksi(teks);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.judul,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ..._ringkasan(widget.item),
              const SizedBox(height: 12),
              fieldLabel(widget.labelCatatan),
              const SizedBox(height: 6),
              TextField(
                controller: _catatan,
                minLines: 3,
                maxLines: 4,
                decoration: inputDecoration(hintText: widget.hint),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AksiTombol(
                        label: widget.labelTolak,
                        bahaya: true,
                        onPressed: () => _kirim(widget.onTolak)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AksiTombol(
                        label: widget.labelSetuju,
                        utama: true,
                        onPressed: () => _kirim(widget.onSetuju)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void tampilkanCatatan(
  BuildContext context, {
  required String judul,
  required Peminjaman item,
  required String labelCatatan,
  required String hint,
  required String labelTolak,
  required String labelSetuju,
  required void Function(String) onTolak,
  required void Function(String) onSetuju,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => _CatatanSheet(
      judul: judul,
      item: item,
      labelCatatan: labelCatatan,
      hint: hint,
      labelTolak: labelTolak,
      labelSetuju: labelSetuju,
      onTolak: onTolak,
      onSetuju: onSetuju,
    ),
  );
}

/// Validasi permintaan peminjaman (Admin).
void validasiPeminjaman(BuildContext context, Peminjaman p) {
  final repo = PeminjamanRepository.instance;
  tampilkanCatatan(
    context,
    judul: 'Validasi Permintaan',
    item: p,
    labelCatatan: 'Catatan Validasi',
    hint: 'Catatan untuk peminjam...',
    labelTolak: 'Tolak',
    labelSetuju: 'Setujui',
    onTolak: (c) {
      repo.tolak(p.id, catatan: c);
      tampilkanSnack(context, 'Permintaan ditolak');
    },
    onSetuju: (c) {
      repo.setujui(p.id, catatan: c);
      tampilkanSnack(context, 'Permintaan disetujui');
    },
  );
}

/// Proses pengembalian barang (Admin).
void prosesPengembalian(BuildContext context, Peminjaman p) {
  final repo = PeminjamanRepository.instance;
  tampilkanCatatan(
    context,
    judul: 'Proses Pengembalian Barang',
    item: p,
    labelCatatan: 'Catatan Pengembalian',
    hint: 'Kondisi barang saat dikembalikan...',
    labelTolak: 'Tolak',
    labelSetuju: 'Selesai',
    onTolak: (c) {
      repo.tolakPengembalian(p.id, catatan: c);
      tampilkanSnack(context, 'Pengembalian ditolak');
    },
    onSetuju: (c) {
      repo.selesaikanPengembalian(p.id, catatan: c);
      tampilkanSnack(context, 'Pengembalian selesai');
    },
  );
}
