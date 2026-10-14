import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/role_guard.dart';
import 'package:inventaris_v_pbm/page/belum_tersedia.dart';
import 'package:inventaris_v_pbm/page/dashboard_user.dart';
import 'package:inventaris_v_pbm/page/dashboard_admin.dart';
import 'package:inventaris_v_pbm/page/peminjaman.dart';
import 'package:inventaris_v_pbm/page/pengembalian.dart';
import 'package:inventaris_v_pbm/page/admin_peminjaman.dart';
import 'package:inventaris_v_pbm/page/admin_pengembalian.dart';
import 'package:inventaris_v_pbm/page/users.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/page/profil.dart';
import 'page/barang.dart';
import 'page/lokasi.dart';
import 'page/katalog.dart';
import 'page/login.dart';
import 'page/kategori.dart';

//Jadi setiap kalian bikin page baru tolong diimport disini.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        //jangan lupa masukin diroute sesuai contoh.
        //untuk nama kayak main.dart itu bisa lihat di sidebar.dart
        'login.dart': (context) => LoginPage(),
        'main.dart': (context) => RoleGuard(
              access: PageAccess.adminOnly,
              child: const AdminDashboardPage(),
            ),
        'barang.dart': (context) => Barang(),
        'lokasi.dart': (context) => LocationLab(),
        'katalog.dart': (context) => Katalog(),
        'kategori.dart': (context) => KategoriPage(),
        'users.dart': (context) => RoleGuard(
              access: PageAccess.adminOnly,
              child: const UsersPage(),
            ),
        'profil_admin.dart': (context) => RoleGuard(
              access: PageAccess.adminOnly,
              child: const ProfilePage(currentRoute: 'profil_admin.dart'),
            ),
        'admin_peminjaman.dart': (context) => RoleGuard(
              access: PageAccess.adminOnly,
              child: const AdminPeminjamanPage(),
            ),
        'admin_pengembalian.dart': (context) => RoleGuard(
              access: PageAccess.adminOnly,
              child: const AdminPengembalianPage(),
            ),
        'peminjaman.dart': (context) => RoleGuard(
              access: PageAccess.userOnly,
              child: const PeminjamanPage(),
            ),
        'pengembalian.dart': (context) => RoleGuard(
              access: PageAccess.userOnly,
              child: const PengembalianPage(),
            ),
        'dashboard_user.dart': (context) => RoleGuard(
              access: PageAccess.userOnly,
              child: const DashboardUserPage(),
            ),
        'profil_user.dart': (context) => RoleGuard(
              access: PageAccess.userOnly,
              child: const ProfilePage(currentRoute: 'profil_user.dart'),
            ),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => BelumTersediaPage(routeName: settings.name ?? '-'),
      ),
    );
  }
}

