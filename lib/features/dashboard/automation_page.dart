import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  _AutomationPageState createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  bool isBuzzerOn = false;

  Future<void> toggleBuzzer(bool state) async {
    final command = state ? 'ON' : 'OFF';
    final url = Uri.parse('http://localhost:3000/actuator/control');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '{"command": "$command"}',
      );

      if (response.statusCode == 200) {
        setState(() {
          isBuzzerOn = state;
        });
      } else {
        throw Exception('Failed to control actuator');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => toggleBuzzer(!isBuzzerOn),
          child: Text(isBuzzerOn ? 'Turn OFF Buzzer' : 'Turn ON Buzzer'),
        ),
        SizedBox(height: 20),
        Text(isBuzzerOn ? 'Buzzer is ON' : 'Buzzer is OFF'),
      ],
    );
  }
}
