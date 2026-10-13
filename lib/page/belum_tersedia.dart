import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/sidennavbar/current_user_app_bar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';

/// Ditampilkan untuk menu di sidebar yang halamannya belum dibuat,
/// agar aplikasi tidak crash saat menu tersebut diklik.
class BelumTersediaPage extends StatelessWidget {
  const BelumTersediaPage({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentUserAppBar(),
      drawer: MyDrawer(currentroute: routeName),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Halaman "$routeName" belum tersedia.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
