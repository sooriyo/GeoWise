import 'package:flutter/material.dart';
import 'package:geowise/features/auth/polytunnel_registration_page.dart';
import 'features/auth/user_details_page.dart';
import 'features/dashboard/dashboard_page.dart';

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
      // home: PolytunnelRegistrationPage(),
      home:  UserDetailsPage(),
      // home: DashboardPage(),
      // home: PolytunnelRegistrationPage(),


    );
  }
}
