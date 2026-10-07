import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/sidennavbar/customAppBar.dart';
import 'package:inventaris_v_pbm/sidennavbar/sidebar.dart';

class Barang extends StatelessWidget {
  const Barang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: MyDrawer(currentroute: 'barang.dart',),
      body: Center(
        child: Text("ini isi dari barang!"),
      ),
    );
  }
}

