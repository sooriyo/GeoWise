import 'package:flutter/material.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  _AutomationPageState createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  bool _automaticMode = false;
  double _temperatureThreshold = 30.0;
  double _soilMoistureThreshold = 40.0;
  double _mistersTemperatureThreshold = 35.0;
  double _mistersHumidityThreshold = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAutomaticModeCard(),
            const SizedBox(height: 16),
            _buildSliderCard(
              'Turn on Fan',
              'Temperature Threshold',
              _temperatureThreshold,
              '°C',
                  (value) {
                setState(() {
                  _temperatureThreshold = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildMistersCard(),
            const SizedBox(height: 16),
            _buildSliderCard(
              'Turn on Watering',
              'Soil Moisture Threshold',
              _soilMoistureThreshold,
              '%',
                  (value) {
                setState(() {
                  _soilMoistureThreshold = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomaticModeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5DF275),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Automatic Mode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Switch(
            value: _automaticMode,
            onChanged: (bool value) {
              setState(() {
                _automaticMode = value;
              });
            },
            activeColor: Colors.white,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMistersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7AFF59),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Turn on Misters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temperature and Humidity Thresholds',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          _buildThresholdSlider(
            'Temperature Threshold',
            _mistersTemperatureThreshold,
            '°C',
                (value) {
              setState(() {
                _mistersTemperatureThreshold = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildThresholdSlider(
            'Humidity Threshold',
            _mistersHumidityThreshold,
            '%',
                (value) {
              setState(() {
                _mistersHumidityThreshold = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildCombinedConditionInfo(),
        ],
      ),
    );
  }

  Widget _buildSliderCard(
      String title,
      String subtitle,
      double value,
      String unit,
      ValueChanged<double> onChanged,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7AFF59),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${value.toStringAsFixed(1)}$unit',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Slider(
                  value: value,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: _automaticMode ? null : onChanged,
                  activeColor: Colors.black,
                  inactiveColor: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdSlider(
      String subtitle,
      double value,
      String unit,
      ValueChanged<double> onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: _automaticMode ? null : onChanged,
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCombinedConditionInfo() {
    return Text(
      'Misters will turn on when both temperature exceeds '
          '${_mistersTemperatureThreshold.toStringAsFixed(1)} °C and humidity exceeds '
          '${_mistersHumidityThreshold.toStringAsFixed(1)} .',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AutomationPage(),
  ));
}
