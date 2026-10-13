import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';
import 'package:inventaris_v_pbm/data/user_repository.dart';
import 'package:inventaris_v_pbm/models/user_account.dart';
import 'package:inventaris_v_pbm/page/user_form.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';

/// Menu Data User (khusus Administrator).
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchController = TextEditingController();
  UserRole? _roleFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserAccount> get _visibleUsers {
    final query = _searchController.text.trim().toLowerCase();
    return UserRepository.instance.users.where((user) {
      final matchesRole = _roleFilter == null || user.role == _roleFilter;
      final matchesQuery = query.isEmpty ||
          user.nama.toLowerCase().contains(query) ||
          user.npmNidn.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
      return matchesRole && matchesQuery;
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openForm({UserAccount? account}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => UserFormPage(account: account)),
    );
    if (saved == true && mounted) {
      setState(() {});
      _showMessage(
        account == null
            ? 'User berhasil ditambahkan.'
            : 'Data user berhasil diperbarui.',
      );
    }
  }

  Future<void> _confirmDelete(UserAccount account) async {
    if (AuthService.instance.currentUser?.id == account.id) {
      _showMessage('Akun yang sedang digunakan tidak dapat dihapus.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Apakah Anda yakin ingin menghapus user '),
                  TextSpan(
                    text: account.nama,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(color: kTextMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    try {
      UserRepository.instance.delete(account.id);
      setState(() {});
      _showMessage('User berhasil dihapus.');
    } on AppException catch (e) {
      _showMessage(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _visibleUsers;
    final currentId = AuthService.instance.currentUser?.id;

    return Scaffold(
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'users.dart'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pengguna sistem',
                  style: TextStyle(color: kTextMuted, fontSize: 13),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah User'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: inputDecoration(hintText: 'Cari nama, NPM/NIDN, atau email...')
                .copyWith(prefixIcon: const Icon(Icons.search, color: kTextMuted)),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<UserRole?>(
            initialValue: _roleFilter,
            decoration: inputDecoration(),
            items: [
              const DropdownMenuItem<UserRole?>(
                value: null,
                child: Text('Semua Role'),
              ),
              for (final role in UserRole.values)
                DropdownMenuItem<UserRole?>(
                  value: role,
                  child: Text(role.label),
                ),
            ],
            onChanged: (value) => setState(() => _roleFilter = value),
          ),
          const SizedBox(height: 16),
          Text(
            'Daftar User · Total: ${users.length}',
            style: const TextStyle(
              color: kTextDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (users.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Tidak ada user yang cocok dengan pencarian.',
                  style: TextStyle(color: kTextMuted),
                ),
              ),
            ),
          for (final user in users) ...[
            _UserCard(
              account: user,
              isSelf: user.id == currentId,
              onEdit: () => _openForm(account: user),
              onDelete: () => _confirmDelete(user),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.account,
    required this.isSelf,
    required this.onEdit,
    required this.onDelete,
  });

  final UserAccount account;
  final bool isSelf;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final details = [account.kelas, account.angkatan, account.noHp]
        .where((value) => value.isNotEmpty)
        .join(' · ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: kInputBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isSelf ? '${account.nama} (Anda)' : account.nama,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RoleBadge(label: account.role.label),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            account.npmNidn,
            style: const TextStyle(color: kTextMuted, fontSize: 13),
          ),
          if (details.isNotEmpty)
            Text(
              details,
              style: const TextStyle(color: kTextMuted, fontSize: 13),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onDelete,
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextDark),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: kTextDark, fontSize: 12),
      ),
    );
  }
}
