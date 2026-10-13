import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:inventaris_v_pbm/models/user_account.dart';

/// Pesan kesalahan yang aman ditampilkan langsung kepada pengguna.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// SHA-256 dengan salt. Password asli tidak pernah disimpan.
String hashPassword(String password, String salt) {
  return sha256.convert(utf8.encode('$salt:$password')).toString();
}

/// PENYIMPANAN SEMENTARA (in-memory).
///
/// Data user hanya ada selama aplikasi berjalan dan kembali ke data awal
/// setiap aplikasi dibuka ulang. Saat backend/database tersedia, ganti isi
/// class ini dengan pemanggilan API atau query database, dengan nama method
/// yang sama agar halaman tidak perlu diubah.
class UserRepository {
  UserRepository._() {
    _seed();
  }

  static final UserRepository instance = UserRepository._();

  final List<UserAccount> _users = [];
  final Random _random = Random.secure();
  int _nextId = 1;

  List<UserAccount> get users => List.unmodifiable(_users);

  UserAccount? findById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  UserAccount? findByEmail(String email) {
    final key = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email.toLowerCase() == key) return user;
    }
    return null;
  }

  bool verifyPassword(UserAccount account, String password) {
    return hashPassword(password, account.passwordSalt) == account.passwordHash;
  }

  UserAccount create({
    required String nama,
    required String npmNidn,
    required String email,
    required String password,
    required UserRole role,
    String kelas = '',
    String angkatan = '',
    String noHp = '',
  }) {
    _ensureUnique(email: email, npmNidn: npmNidn);
    final salt = _newSalt();
    final account = UserAccount(
      id: (_nextId++).toString(),
      nama: nama.trim(),
      npmNidn: npmNidn.trim(),
      email: email.trim(),
      role: role,
      kelas: kelas.trim(),
      angkatan: angkatan.trim(),
      noHp: noHp.trim(),
      passwordHash: hashPassword(password, salt),
      passwordSalt: salt,
    );
    _users.add(account);
    return account;
  }

  /// Menyimpan perubahan data akun yang sudah ada.
  void save(UserAccount account) {
    final index = _users.indexWhere((user) => user.id == account.id);
    if (index == -1) {
      throw const AppException('Akun tidak ditemukan.');
    }
    _ensureUnique(
      email: account.email,
      npmNidn: account.npmNidn,
      exceptId: account.id,
    );
    _users[index] = account;
  }

  void delete(String id) {
    final before = _users.length;
    _users.removeWhere((user) => user.id == id);
    if (_users.length == before) {
      throw const AppException('Akun tidak ditemukan.');
    }
  }

  /// Mengembalikan salinan akun dengan password baru yang sudah di-hash.
  /// Panggil [save] untuk menyimpannya.
  UserAccount withPassword(UserAccount account, String newPassword) {
    final salt = _newSalt();
    return account.copyWith(
      passwordHash: hashPassword(newPassword, salt),
      passwordSalt: salt,
    );
  }

  void _ensureUnique({
    required String email,
    required String npmNidn,
    String? exceptId,
  }) {
    final emailKey = email.trim().toLowerCase();
    final npmKey = npmNidn.trim();
    for (final user in _users) {
      if (user.id == exceptId) continue;
      if (user.email.toLowerCase() == emailKey) {
        throw const AppException('Email sudah digunakan oleh akun lain.');
      }
      if (user.npmNidn == npmKey) {
        throw const AppException('NPM / NIDN sudah terdaftar.');
      }
    }
  }

  String _newSalt() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  /// Data awal untuk pengujian UI. Password hanya dipakai di sini untuk
  /// dihash; di penyimpanan hanya tersimpan hash dan salt-nya.
  void _seed() {
    create(
      nama: 'Halvina Farras Savitri',
      npmNidn: '2410631170071',
      email: '2410631170071@unsika.ac.id',
      password: 'halvina1234',
      role: UserRole.mahasiswa,
      kelas: 'TI-3A',
      angkatan: '2021',
      noHp: '081234567891',
    );
    create(
      nama: 'Admin Laboratorium',
      npmNidn: '0000000001',
      email: 'admin@unsika.ac.id',
      password: 'admin1234',
      role: UserRole.administrator,
    );
  }
}
