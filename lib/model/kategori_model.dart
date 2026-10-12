
class Kategori {
  String nama;
  String deskripsi;

  Kategori({
    required this.nama,
    required this.deskripsi,
  });
}

class DataBarangInventaris {
  final String nama;
  final String kategori;

  DataBarangInventaris({
    required this.nama,
    required this.kategori,
  });
}
