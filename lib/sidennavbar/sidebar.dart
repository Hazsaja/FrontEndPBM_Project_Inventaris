import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/auth/auth_service.dart';


class MyDrawer extends StatelessWidget {

  final String currentroute;

  const MyDrawer({super.key, this.currentroute = 'main.dart'});

  @override
  Widget build(BuildContext context) {

    const backgroundColor = Color(0xFF1E293B);
    const activeColor = Color(0xFF3B82F6);
    const borderColor = Color(0xFF1E40AF);
    const subtextColor = Color(0xFFBFDBFE);

    // Menu mengikuti role user yang sedang login.
    final user = AuthService.instance.currentUser;
    final isAdmin = user?.role.isAdmin ?? false;

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Lab Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        isAdmin ? 'Admin Panel' : 'Student Portal',
                        style: const TextStyle(
                          color: subtextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                children: isAdmin
                    ? _adminNavItems(context, activeColor)
                    : _userNavItems(context, activeColor),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: activeColor,
                            child: Text(
                              user.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user.nama,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  user.role.label,
                                  style: const TextStyle(
                                    color: subtextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(Icons.logout, color: Colors.white, size: 20),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      AuthService.instance.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        'login.dart',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _adminNavItems(BuildContext context, Color activeColor) {
    return [
      _buildNavItem(
        context: context,
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        route: 'main.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.inventory_2_outlined,
        label: 'Data Barang',
        route: 'barang.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.account_tree_outlined,
        label: 'Kategori Barang',
        route: 'kategori.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.location_on_outlined,
        label: 'Lokasi Penyimpanan',
        route: 'lokasi.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.people_outline,
        label: 'Data User',
        route: 'users.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.assignment_turned_in_outlined,
        label: 'Peminjaman Barang',
        route: 'admin_peminjaman.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.rotate_left,
        label: 'Pengembalian Barang',
        route: 'admin_pengembalian.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.description_outlined,
        label: 'Laporan Inventaris',
        route: 'laporan.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.history,
        label: 'Riwayat Aktivitas',
        route: 'aktivitas.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.person_outline,
        label: 'Profil',
        route: 'profil_admin.dart',
        activeColor: activeColor,
      ),
    ];
  }

  List<Widget> _userNavItems(BuildContext context, Color activeColor) {
    return [
      _buildNavItem(
        context: context,
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        route: 'dashboard_user.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.inventory_2_outlined,
        label: 'Katalog Barang',
        route: 'katalog.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.assignment_turned_in_outlined,
        label: 'Peminjaman Barang',
        route: 'peminjaman.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.rotate_left,
        label: 'Pengembalian Barang',
        route: 'pengembalian.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.history,
        label: 'Riwayat Peminjaman',
        route: 'riwayat.dart',
        activeColor: activeColor,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.person_outline,
        label: 'Profil Saya',
        route: 'profil_user.dart',
        activeColor: activeColor,
      ),
    ];
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required Color activeColor,
  }) {
    final bool isActive = currentroute == route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        selected: isActive,
        selectedTileColor: activeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (!isActive) {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(route);
          }
        },
      ),
    );
  }
}
