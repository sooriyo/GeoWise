// lib/features/auth/wifi_credentials_page.dart
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'user_details_page.dart';

class WiFiCredentialsPage extends StatefulWidget {
  @override
  _WiFiCredentialsPageState createState() => _WiFiCredentialsPageState();
}

class _WiFiCredentialsPageState extends State<WiFiCredentialsPage> {
  List<WifiNetwork> _wifiNetworks = [];
  String? _selectedSSID;
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scanForWiFiNetworks();
  }

  Future<void> scanForWiFiNetworks() async {
    bool isEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isEnabled) {
      await WiFiForIoTPlugin.setEnabled(true);
    }

    List<WifiNetwork>? wifiNetworks = await WiFiForIoTPlugin.loadWifiList();
    if (wifiNetworks != null) {
      setState(() {
        _wifiNetworks = wifiNetworks;
      });
    }
  }

  Future<void> sendCredentials(String ssid, String password) async {
    var url = Uri.parse('http://192.168.4.1/submit');
    var response = await http.post(url, body: {'ssid': ssid, 'password': password});
    if (response.statusCode == 200) {
      print('Credentials sent successfully');
    } else {
      print('Failed to send credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select ESP32 AP'),
              value: _selectedSSID,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSSID = newValue;
                  ssidController.text = newValue!;
                });
              },
              items: _wifiNetworks
                  .map<DropdownMenuItem<String>>((WifiNetwork network) {
                return DropdownMenuItem<String>(
                  value: network.ssid,
                  child: Text(network.ssid!),
                );
              }).toList(),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'WiFi Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_selectedSSID != null) {
                  await sendCredentials(_selectedSSID!, passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsPage()),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
