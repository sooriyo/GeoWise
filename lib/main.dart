// lib/main.dart
import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';

void main() {
  runApp(GeoWiseApp());
}

class GeoWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoWise',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DashboardPage(),
    );
  }
}
