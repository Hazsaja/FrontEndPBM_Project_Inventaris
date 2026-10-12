import 'package:flutter/material.dart';
import '../model/kategori_model.dart';

class KategoriFormDialog extends StatefulWidget {
  final Kategori? kategori;
  final List<String> namaKategori;

  const KategoriFormDialog({
    super.key,
    this.kategori,
    required this.namaKategori,
  });

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController namaController;
  late final TextEditingController deskripsiController;

  bool get sedangEdit => widget.kategori != null;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.kategori?.nama ?? '');

    deskripsiController = TextEditingController(
      text: widget.kategori?.deskripsi ?? '',
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  void simpan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(<String, String>{
      'nama': namaController.text.trim(),
      'deskripsi': deskripsiController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(sedangEdit ? 'Edit Kategori' : 'Tambah Kategori'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    hintText: 'Contoh: Elektronik',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama kategori wajib diisi';
                    }

                    final nama = value.trim().toLowerCase();

                    final namaLama = widget.kategori?.nama.toLowerCase();

                    final duplikat = widget.namaKategori.any((item) {
                      return item.toLowerCase() == nama &&
                          item.toLowerCase() != namaLama;
                    });

                    if (duplikat) {
                      return 'Nama kategori sudah digunakan';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Masukkan deskripsi kategori',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi wajib diisi';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: simpan,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
