import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/auth/validators.dart';
import 'package:inventaris_v_pbm/data/user_repository.dart';
import 'package:inventaris_v_pbm/models/user_account.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';

/// Halaman Profil untuk Administrator (profil_admin.dart) dan user biasa
/// (profil_user.dart). Selalu menampilkan data user yang sedang login.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _npmController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _kelasController = TextEditingController();
  final _angkatanController = TextEditingController();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      _namaController.text = user.nama;
      _npmController.text = user.npmNidn;
      _emailController.text = user.email;
      _noHpController.text = user.noHp;
      _kelasController.text = user.kelas;
      _angkatanController.text = user.angkatan;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _npmController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _kelasController.dispose();
    _angkatanController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isMahasiswa =>
      AuthService.instance.currentUser?.role == UserRole.mahasiswa;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveProfile() {
    if (!_profileFormKey.currentState!.validate()) return;

    final user = AuthService.instance.currentUser;
    if (user == null) {
      _showMessage('Sesi berakhir. Silakan login ulang.');
      return;
    }

    try {
      // NPM/NIDN dan password sengaja tidak ikut diubah di sini.
      UserRepository.instance.save(
        user.copyWith(
          nama: _namaController.text.trim(),
          email: _emailController.text.trim(),
          noHp: _noHpController.text.trim(),
          kelas: _kelasController.text.trim(),
          angkatan: _angkatanController.text.trim(),
        ),
      );
      setState(() {});
      _showMessage('Profil berhasil disimpan.');
    } on AppException catch (e) {
      _showMessage(e.message);
    }
  }

  void _updatePassword() {
    if (!_passwordFormKey.currentState!.validate()) return;

    try {
      AuthService.instance.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {});
      _showMessage('Password berhasil diubah.');
    } on AppException catch (e) {
      _showMessage(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Sesi tidak ditemukan. Silakan login ulang.')),
      );
    }

    return Scaffold(
      appBar: currentUserAppBar(),
      drawer: MyDrawer(currentroute: widget.currentRoute),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil',
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Kelola informasi profil Anda',
                      style: TextStyle(color: kTextMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _saveProfile,
                child: const Text('Simpan Profil'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: kPrimaryBlue,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.nama,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.role.label,
                  style: const TextStyle(color: kTextMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _profileFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labeledField(
                  'Nama Lengkap',
                  TextFormField(
                    controller: _namaController,
                    decoration: inputDecoration(hintText: 'Nama lengkap'),
                    validator: (value) =>
                        Validators.requiredField(value, 'Nama lengkap'),
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Email',
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(hintText: 'email@unsika.ac.id'),
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Nomor HP / WhatsApp',
                  TextFormField(
                    controller: _noHpController,
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration(hintText: '081234567890'),
                    validator: Validators.phone,
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Kelas',
                  TextFormField(
                    controller: _kelasController,
                    decoration: inputDecoration(hintText: 'TI-3A'),
                    validator: (value) => _isMahasiswa
                        ? Validators.requiredField(value, 'Kelas')
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Angkatan',
                  TextFormField(
                    controller: _angkatanController,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(hintText: '2021'),
                    validator: (value) {
                      if (_isMahasiswa) {
                        final requiredError =
                            Validators.requiredField(value, 'Angkatan');
                        if (requiredError != null) return requiredError;
                      }
                      return Validators.angkatan(value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'NPM / NIDN (Tidak Dapat Diubah)',
                  TextFormField(
                    controller: _npmController,
                    readOnly: true,
                    decoration: inputDecoration(readOnly: true),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Ubah Password',
            style: TextStyle(
              color: kTextDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: _passwordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labeledField(
                  'Password Lama',
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOld,
                    decoration: inputDecoration(
                      suffixIcon: _visibilityToggle(
                        _obscureOld,
                        () => setState(() => _obscureOld = !_obscureOld),
                      ),
                    ),
                    validator: (value) =>
                        Validators.requiredField(value, 'Password lama'),
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Password Baru',
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    decoration: inputDecoration(
                      hintText: 'Minimal 8 karakter',
                      suffixIcon: _visibilityToggle(
                        _obscureNew,
                        () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    validator: (value) {
                      final passwordError = Validators.password(value);
                      if (passwordError != null) return passwordError;
                      if (value == _oldPasswordController.text) {
                        return 'Password baru harus berbeda dari password lama.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                labeledField(
                  'Konfirmasi Password Baru',
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: inputDecoration(
                      suffixIcon: _visibilityToggle(
                        _obscureConfirm,
                        () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (value) {
                      final requiredError =
                          Validators.requiredField(value, 'Konfirmasi password');
                      if (requiredError != null) return requiredError;
                      if (value != _newPasswordController.text) {
                        return 'Konfirmasi password tidak cocok.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _updatePassword,
                    child: const Text('Update Password'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _visibilityToggle(bool obscured, VoidCallback onPressed) {
    return IconButton(
      tooltip: obscured ? 'Tampilkan password' : 'Sembunyikan password',
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: kTextMuted,
      ),
      onPressed: onPressed,
    );
  }
}
