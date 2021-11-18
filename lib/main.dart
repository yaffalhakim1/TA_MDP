import 'dart:io';

import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir_mdp/screens/home.dart';
import 'package:tugas_akhir_mdp/screens/maps.dart';
import 'package:tugas_akhir_mdp/screens/profile.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(Laborant());
}

class Laborant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingNavBar(
        cardWidth: 30,
        items: [
          FloatingNavBarItem(
            iconData: Icons.home,
            page: Home(),
            title: 'Home',
          ),
          FloatingNavBarItem(
            iconData: Icons.map,
            title: 'Maps',
            page: MapsView(),
          ),
          FloatingNavBarItem(
            iconData: Icons.person_rounded,
            title: 'Maps',
            page: Profile(),
          ),
        ],
        color: Color(0xff0F1923),
        selectedIconColor: Colors.white,
        unselectedIconColor: Colors.white.withOpacity(0.6),
        horizontalPadding: 10.0,
        hapticFeedback: true,
        showTitle: false,
      ),
    );
  }
}
