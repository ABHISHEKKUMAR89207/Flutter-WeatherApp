import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ForecastPage(),
    );
  }
}

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  String _cityName = '';
  int _numberOfDays = 1;
  List<WeatherData> _weatherData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecast Page'),
        backgroundColor: Color.fromARGB(255, 10, 95, 105),
        elevation: 10,
      ),
      backgroundColor: Color.fromARGB(255, 159, 213, 219),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(labelText: 'Enter City'),
                controller: TextEditingController(text: _cityName),
              ),
              suggestionsCallback: (pattern) async {
                final suggestions = await fetchIndianCitySuggestions(pattern);
                return suggestions;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _cityName = suggestion;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  'Number of Days:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 16),
                DropdownButton<int>(
                  value: _numberOfDays,
                  onChanged: (value) {
                    setState(() {
                      _numberOfDays = value!;
                    });
                  },
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _fetchWeatherData(_cityName, _numberOfDays);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            if (_weatherData.isNotEmpty)
              Column(
                children: _weatherData.map((data) {
                  return WeatherCard(data: data);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchWeatherData(String cityName, int numberOfDays) async {
    final apiKey = 'd610395e85b50074b834a0234b0776db';
    final apiUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&cnt=$numberOfDays&appid=$apiKey');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<WeatherData> forecastData = [];

      for (final item in data['list']) {
        final date = item['dt_txt'];
        final temperature = item['main']['temp'] - 273.15;
        final weatherCondition = item['weather'][0]['main'];

        final weather = WeatherData(
          date: date,
          temperature: temperature,
          weatherCondition: weatherCondition,
        );

        forecastData.add(weather);
      }

      setState(() {
        _weatherData = forecastData;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch weather data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<String>> fetchIndianCitySuggestions(String pattern) async {
    final List<String> indianCities = [
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Kolkata',
      'Chennai',
      'Hyderabad',
      'Pune',
      'Jaipur',
      'Ahmedabad',
      'Lucknow',
      'Kanpur',
      'Nagpur',
      'Surat',
      'Varanasi',
      'Agra',
    ];

    return indianCities
        .where((city) => city.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }
}

class WeatherData {
  final String date;
  final double temperature;
  final String weatherCondition;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.weatherCondition,
  });
}

class WeatherCard extends StatelessWidget {
  final WeatherData data;

  WeatherCard({required this.data});

  IconData getWeatherIcon() {
    switch (data.weatherCondition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access;

      default:
        return Icons.error;
    }
  }

  Color getBackgroundColor() {
    switch (data.weatherCondition) {
      case 'Clear':
        return Colors.yellow[200]!;
      case 'Clouds':
        return Colors.blue[200]!;
      case 'Rain':
        return Colors.grey[300]!;

      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: getBackgroundColor(), // Set the background color here
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(
              getWeatherIcon(), // Set the weather icon here
              size: 48,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${data.date}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Temperature: ${data.temperature.toStringAsFixed(2)}°C',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Weather Condition: ${data.weatherCondition}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
