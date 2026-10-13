import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/auth/validators.dart';
import 'package:inventaris_v_pbm/data/user_repository.dart';
import 'package:inventaris_v_pbm/models/user_account.dart';

/// Form Tambah User (account == null) dan Edit User (account != null).
/// Mengembalikan true ke halaman sebelumnya jika data berhasil disimpan.
class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key, this.account});

  final UserAccount? account;

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _npmController;
  late final TextEditingController _emailController;
  late final TextEditingController _kelasController;
  late final TextEditingController _angkatanController;
  late final TextEditingController _noHpController;
  final _passwordController = TextEditingController();
  late UserRole _role;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _namaController = TextEditingController(text: account?.nama ?? '');
    _npmController = TextEditingController(text: account?.npmNidn ?? '');
    _emailController = TextEditingController(text: account?.email ?? '');
    _kelasController = TextEditingController(text: account?.kelas ?? '');
    _angkatanController = TextEditingController(text: account?.angkatan ?? '');
    _noHpController = TextEditingController(text: account?.noHp ?? '');
    _role = account?.role ?? UserRole.mahasiswa;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _npmController.dispose();
    _emailController.dispose();
    _kelasController.dispose();
    _angkatanController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateKelas(String? value) {
    if (_role == UserRole.mahasiswa) {
      return Validators.requiredField(value, 'Kelas');
    }
    return null;
  }

  String? _validateAngkatan(String? value) {
    if (_role == UserRole.mahasiswa) {
      final requiredError = Validators.requiredField(value, 'Angkatan');
      if (requiredError != null) return requiredError;
    }
    return Validators.angkatan(value);
  }

  void _save() {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    final repository = UserRepository.instance;
    final password = _passwordController.text;

    try {
      final account = widget.account;
      if (account == null) {
        repository.create(
          nama: _namaController.text,
          npmNidn: _npmController.text,
          email: _emailController.text,
          password: password,
          role: _role,
          kelas: _kelasController.text,
          angkatan: _angkatanController.text,
          noHp: _noHpController.text,
        );
      } else {
        final isSelf = AuthService.instance.currentUser?.id == account.id;
        if (isSelf && account.role.isAdmin && !_role.isAdmin) {
          throw const AppException(
            'Anda tidak dapat mengubah role akun sendiri dari Administrator.',
          );
        }

        var updated = account.copyWith(
          nama: _namaController.text.trim(),
          npmNidn: _npmController.text.trim(),
          email: _emailController.text.trim(),
          role: _role,
          kelas: _kelasController.text.trim(),
          angkatan: _angkatanController.text.trim(),
          noHp: _noHpController.text.trim(),
        );
        if (password.isNotEmpty) {
          updated = repository.withPassword(updated, password);
        }
        repository.save(updated);
      }
      Navigator.of(context).pop(true);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isEdit ? 'Edit User' : 'Tambah User Baru',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) ...[
                FormErrorBanner(message: _errorMessage!),
                const SizedBox(height: 16),
              ],
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
                'NPM / NIDN',
                TextFormField(
                  controller: _npmController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration(hintText: 'NPM / NIDN'),
                  validator: Validators.npm,
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
                'Password',
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: inputDecoration(
                    hintText: _isEdit
                        ? 'Kosongkan jika tidak diubah'
                        : 'Minimal 8 karakter',
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Tampilkan password'
                          : 'Sembunyikan password',
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: kTextMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) =>
                      Validators.password(value, optional: _isEdit),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: labeledField(
                      'Role',
                      DropdownButtonFormField<UserRole>(
                        initialValue: _role,
                        decoration: inputDecoration(),
                        items: [
                          for (final role in UserRole.values)
                            DropdownMenuItem<UserRole>(
                              value: role,
                              child: Text(role.label),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _role = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: labeledField(
                      'Kelas',
                      TextFormField(
                        controller: _kelasController,
                        decoration: inputDecoration(hintText: 'TI-3A'),
                        validator: _validateKelas,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: labeledField(
                      'Angkatan',
                      TextFormField(
                        controller: _angkatanController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration(hintText: '2021'),
                        validator: _validateAngkatan,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: labeledField(
                      'No HP',
                      TextFormField(
                        controller: _noHpController,
                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration(hintText: '0812...'),
                        validator: Validators.phone,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isEdit) ...[
                const SizedBox(height: 12),
                const Text(
                  'Saat edit: kosongkan kolom Password jika tidak ingin diubah.',
                  style: TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _save,
                        child: const Text('Simpan'),
                      ),
                    ),
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
