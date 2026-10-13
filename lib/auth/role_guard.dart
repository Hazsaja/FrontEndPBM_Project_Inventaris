import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/auth/form_widgets.dart';

/// Hak akses sebuah halaman.
enum PageAccess { adminOnly, userOnly }

/// Hanya menampilkan [child] jika user yang login sesuai [access].
class RoleGuard extends StatelessWidget {
  const RoleGuard({super.key, required this.access, required this.child});

  final PageAccess access;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    if (user == null) {
      return _AccessDenied(
        message: 'Anda belum login. Silakan login terlebih dahulu.',
        buttonLabel: 'Ke halaman login',
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          'login.dart',
          (route) => false,
        ),
      );
    }

    final allowed = access == PageAccess.adminOnly
        ? user.role.isAdmin
        : !user.role.isAdmin;
    if (allowed) return child;

    return _AccessDenied(
      message: 'Halaman ini tidak dapat diakses dengan role ${user.role.label}.',
      buttonLabel: 'Kembali ke dashboard',
      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
        homeRouteFor(user.role),
        (route) => false,
      ),
    );
  }
}

class _AccessDenied extends StatelessWidget {
  const _AccessDenied({
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: kTextMuted),
              const SizedBox(height: 16),
              const Text(
                'Akses ditolak',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
