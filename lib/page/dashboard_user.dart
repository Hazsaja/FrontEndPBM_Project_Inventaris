import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';

/// Placeholder dashboard untuk user biasa (Mahasiswa/Laboran).
/// Isi dashboard belum termasuk tugas fitur login/profil ini.
class DashboardUserPage extends StatelessWidget {
  const DashboardUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: currentUserAppBar(),
      drawer: const MyDrawer(currentroute: 'dashboard_user.dart'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            user == null
                ? 'Dashboard'
                : 'Selamat datang, ${user.nama}.\nDashboard user belum dikerjakan.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
