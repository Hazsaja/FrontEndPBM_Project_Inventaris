import 'package:flutter/material.dart';
import 'package:inventaris_v_pbm/sidennavbar/customAppBar.dart';
import 'sidennavbar/sidebar.dart';
import 'page/barang.dart';
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
      home: HomePage(),

      routes: {
        //jangan lupa masukin diroute sesuai contoh.
        //untuk nama kayak main.dart itu bisa lihat di sidebar.dart
        'main.dart': (context) => HomePage(),
        'barang.dart': (context) => Barang(),
        'kategori.dart': (context) => KategoriPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //nanti saat kalian bikin appbar tinggal pakai CustomAppBar(jangan lupa import)
      appBar: CustomAppBar(),
      //untuk sidebar pake drawer trs pake MyDrawer dan currentroute nya sama kayak nama filenya.
      drawer: MyDrawer(currentroute: 'main.dart'),
      //disini nanti isinya lihat contoh barang.dart di folder page
      body: Center(child: Text("Content dari Dashboard")),
    );
  }
}
