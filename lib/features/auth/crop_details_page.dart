import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../dashboard/dashboard_page.dart';

class CropDetailsPage extends StatefulWidget {
  CropDetailsPage({super.key});

  @override
  _CropDetailsPageState createState() => _CropDetailsPageState();
}

class _CropDetailsPageState extends State<CropDetailsPage> {
  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController plantedDateController = TextEditingController();
  final TextEditingController cropAmountController = TextEditingController();
  final TextEditingController varietyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> varieties = [
    'Capsicum',
    'Bell Pepper',
    'Green Chilli',
    'Salad Cucumber',
    'Hot Pepper',
    'Tomato'
  ];

  @override
  void dispose() {
    cropNameController.dispose();
    plantedDateController.dispose();
    cropAmountController.dispose();
    varietyController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        Dio dio = Dio();
        final response = await dio.post(
          'http://192.168.8.191:3000/crop',
          data: {
            'name': cropNameController.text,
            'variety': varietyController.text,
            'plantDate': plantedDateController.text,
            'cropAmount': int.parse(cropAmountController.text),  // Correct key and parsing
            'polytunnelId': 1,  // Ensure this ID is correct
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 201) {
          print('Crop successfully created');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
                (route) => false,
          );
        } else {
          print('Failed to create crop: ${response.statusCode}');
          print(response.data);  // Log the response data
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create crop')),
          );
        }
      } catch (e) {
        print('Error: $e');
        if (e is DioError && e.response != null) {
          print('Response data: ${e.response?.data}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Details'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cropNameController,
                decoration: InputDecoration(
                  labelText: 'Crop Name',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: varieties.map((String variety) {
                  return DropdownMenuItem<String>(
                    value: variety,
                    child: Text(variety),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    varietyController.text = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Variety',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a variety';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: plantedDateController,
                decoration: InputDecoration(
                  labelText: 'Planted Date',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      plantedDateController.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a planted date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cropAmountController,
                decoration: InputDecoration(
                  labelText: 'Plant Quantity',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plant quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await _submit(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
