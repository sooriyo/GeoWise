// lib/features/dashboard/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:    const Text(
        'Welcome Alina!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                    title: 'Temperature',
                    value: '43°',
                    color: Colors.lightGreenAccent,
                    child: _buildGaugeChart(),
                  ),
                  _buildCard(
                    title: 'Humidity',
                    value: '100mm',
                    color: Colors.lightGreenAccent,
                    child: _buildBarChart(),
                  ),
                  _buildCard(
                    title: 'Soil Moisture',
                    value: '43%',
                    color: Colors.lightGreenAccent,
                    child: _buildLineChart(),
                  ),
                  _buildCard(
                    title: 'PH Level',
                    value: '43%',
                    color: Colors.lightGreenAccent,
                    child: const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Farming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Roots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildCard({required String title, required String value, required Color color, required Widget child}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildGaugeChart() {
    return const Center(
      child: Text(
        'Gauge Chart Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildBarChart() {
    return const Center(
      child: Text(
        'Bar Chart Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 3),
              const FlSpot(2, 2),
              const FlSpot(3, 5),
              const FlSpot(4, 3),
            ],
            isCurved: true,
            color: Colors.green,  // Updated parameter
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
