import 'package:inventaris_v_pbm/auth/auth_service.dart';
import 'package:inventaris_v_pbm/sidennavbar/customAppBar.dart';

/// CustomAppBar yang menampilkan nama, role, dan inisial user yang sedang login.
CustomAppBar currentUserAppBar() {
  final user = AuthService.instance.currentUser;
  if (user == null) return const CustomAppBar();
  return CustomAppBar(
    userName: user.nama,
    userRole: user.role.label,
    userInitials: user.initials,
  );
}
