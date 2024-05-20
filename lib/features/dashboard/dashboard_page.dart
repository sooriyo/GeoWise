import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:geowise/features/dashboard/settings_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'automation_page.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  int _currentIndex = 0;
  late MqttServerClient client;

  String moisture = "Loading...";
  String humidity = "Loading...";
  String temperatureC = "Loading...";

  static const String mqttServer = "15.235.192.41";
  static const int mqttPort = 1883;
  static const String mqttUser = "thimira";
  static const String mqttPassword = "371701";
  static const String mqttTopic = "geowise/sensor";

  @override
  void initState() {
    super.initState();
    _connectToMQTT();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 0;
        });
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> _connectToMQTT() async {
    client = MqttServerClient(mqttServer, '');
    client.port = mqttPort;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.logging(on: true);

    final connMessage = MqttConnectMessage()
        .authenticateAs(mqttUser, mqttPassword)
        .withClientIdentifier('GeoWiseClient')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      _disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected');
      client.subscribe(mqttTopic, MqttQos.atMostOnce);
      client.updates!.listen(_onMessage);
    } else {
      print(
          'ERROR: MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      _disconnect();
    }
  }

  void _onDisconnected() {
    print('Disconnected');
  }

  void _onConnected() {
    print('Connected');
  }

  void _disconnect() {
    client.disconnect();
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('MQTT message: topic is <${event[0].topic}>, payload is <-- $message -->');

    final data = jsonDecode(message);
    setState(() {
      moisture = data['moisture'].toString();
      humidity = data['humidity'].toString();
      temperatureC = data['temperatureC'].toString();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _disconnect();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const AutomationPage();
      case 2:
        return SettingsPage();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Humidity', 'Current Level', humidity, const Color(0xFF1C1C1C), Colors.white),
                _buildInfoCard('Soil Moisture', 'Current Level', moisture, const Color(0xFFB6FF59), Colors.black),
              ],
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: 150,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildTemperatureCard('Temperature', 'Inside Polytunnel', temperatureC, 'C', const Color(0xFF7AFF59), Colors.black),
                  _buildTemperatureCard('Temperature', 'Soil Temperature', temperatureC, 'C', const Color(0xFF7AFF59), Colors.black),
                  _buildTemperatureCard('Temperature', 'Outside Polytunnel', temperatureC, 'C', const Color(0xFF7AFF59), Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index == _currentPage)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconCard(Icons.water_drop),
                _buildIconCard(Icons.mode_fan_off_sharp),
                _buildIconCard(Icons.notifications_active),
              ],
            ),
            const SizedBox(height: 16),
            _buildCameraCard(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: const [
          Icon(Icons.person, color: Colors.black),
          SizedBox(width: 45),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, String value, Color bgColor, Color textColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard(String title, String subtitle, String value, String unit, Color bgColor, Color textColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$value°$unit',
                style: TextStyle(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 1),
                      const FlSpot(1, 3),
                      const FlSpot(2, 2),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4),
                    ],
                    isCurved: true,
                    color: Colors.black,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildIconCard(IconData icon) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(29),
      ),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }

  Widget _buildCameraCard() {
    return Container(
      width: double.infinity,
      height: 165,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Text(
          'No camera Detected',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
