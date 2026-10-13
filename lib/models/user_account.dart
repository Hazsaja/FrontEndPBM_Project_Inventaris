/// Role akun sesuai pilihan pada wireframe (Mahasiswa, Laboran, Administrator).
enum UserRole {
  mahasiswa('Mahasiswa'),
  laboran('Laboran'),
  administrator('Administrator');

  const UserRole(this.label);

  final String label;

  /// Hanya Administrator yang boleh mengakses panel admin.
  bool get isAdmin => this == UserRole.administrator;
}

class UserAccount {
  const UserAccount({
    required this.id,
    required this.nama,
    required this.npmNidn,
    required this.email,
    required this.role,
    required this.kelas,
    required this.angkatan,
    required this.noHp,
    required this.passwordHash,
    required this.passwordSalt,
  });

  final String id;
  final String nama;
  final String npmNidn;
  final String email;
  final UserRole role;
  final String kelas;
  final String angkatan;
  final String noHp;

  /// Password tidak pernah disimpan dalam bentuk teks biasa.
  final String passwordHash;
  final String passwordSalt;

  UserAccount copyWith({
    String? nama,
    String? npmNidn,
    String? email,
    UserRole? role,
    String? kelas,
    String? angkatan,
    String? noHp,
    String? passwordHash,
    String? passwordSalt,
  }) {
    return UserAccount(
      id: id,
      nama: nama ?? this.nama,
      npmNidn: npmNidn ?? this.npmNidn,
      email: email ?? this.email,
      role: role ?? this.role,
      kelas: kelas ?? this.kelas,
      angkatan: angkatan ?? this.angkatan,
      noHp: noHp ?? this.noHp,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
    );
  }

  /// Inisial untuk avatar, contoh: "Anisa Diyah" -> "AD".
  String get initials {
    final words = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    final first = words.first[0];
    final second = words.length > 1 ? words[1][0] : '';
    return (first + second).toUpperCase();
  }
}
