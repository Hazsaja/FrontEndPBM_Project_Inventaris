import 'package:inventaris_v_pbm/data/user_repository.dart';
import 'package:inventaris_v_pbm/models/user_account.dart';

/// Halaman awal setelah login sesuai role akun.
String homeRouteFor(UserRole role) {
  return role.isAdmin ? 'main.dart' : 'dashboard_user.dart';
}

/// Mengelola sesi login (sementara, di memori aplikasi).
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final UserRepository _repository = UserRepository.instance;
  String? _currentUserId;

  /// Data user yang sedang login, selalu dibaca ulang dari penyimpanan
  /// sehingga perubahan profil langsung terlihat.
  UserAccount? get currentUser {
    final id = _currentUserId;
    return id == null ? null : _repository.findById(id);
  }

  UserAccount login(String email, String password) {
    final account = _repository.findByEmail(email);
    if (account == null || !_repository.verifyPassword(account, password)) {
      throw const AppException('Email atau password salah.');
    }
    _currentUserId = account.id;
    return account;
  }

  void logout() {
    _currentUserId = null;
  }

  void changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    final user = currentUser;
    if (user == null) {
      throw const AppException('Sesi berakhir. Silakan login ulang.');
    }
    if (!_repository.verifyPassword(user, oldPassword)) {
      throw const AppException('Password lama tidak sesuai.');
    }
    _repository.save(_repository.withPassword(user, newPassword));
  }
}
