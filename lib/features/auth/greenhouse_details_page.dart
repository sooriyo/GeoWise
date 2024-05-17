// lib/features/auth/greenhouse_details_page.dart
import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';

class GreenhouseDetailsPage extends StatelessWidget {
  final TextEditingController greenhouseNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greenhouse Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: greenhouseNameController,
              decoration: InputDecoration(labelText: 'Greenhouse Name'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Finalize setup and navigate to Dashboard
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
