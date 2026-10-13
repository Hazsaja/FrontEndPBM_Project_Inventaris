/// Validasi input form. Setiap method mengembalikan null jika valid.
class Validators {
  Validators._();

  static String? requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, 'Email');
    if (requiredError != null) return requiredError;
    final pattern = RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');
    return pattern.hasMatch(value!.trim()) ? null : 'Format email tidak valid.';
  }

  static String? npm(String? value) {
    final requiredError = requiredField(value, 'NPM / NIDN');
    if (requiredError != null) return requiredError;
    return RegExp(r'^\d{6,20}$').hasMatch(value!.trim())
        ? null
        : 'NPM / NIDN hanya boleh berisi angka (6–20 digit).';
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^\d{9,15}$').hasMatch(text)
        ? null
        : 'Nomor HP hanya boleh berisi angka (9–15 digit).';
  }

  static String? angkatan(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^\d{4}$').hasMatch(text)
        ? null
        : 'Angkatan harus 4 digit, contoh: 2021.';
  }

  /// Password baru minimal 8 karakter. Jika [optional] true, kosong dianggap valid
  /// (dipakai saat edit user yang tidak ingin mengganti password).
  static String? password(String? value, {bool optional = false}) {
    final text = value ?? '';
    if (text.isEmpty) {
      return optional ? null : 'Password wajib diisi.';
    }
    if (text.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    return null;
  }
}
