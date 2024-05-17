// lib/main.dart
import 'package:flutter/material.dart';
import 'features/auth/user_details_page.dart';
import 'features/auth/wifi_credentials_page.dart';

void main() {
  runApp(const GeoWiseApp());
}

class GeoWiseApp extends StatelessWidget {
  const GeoWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoWise',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: UserDetailsPage(),
    );
  }
}
