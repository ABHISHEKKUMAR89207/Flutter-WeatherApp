import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MaterialApp(
    home: WeatherPage(),
  ));
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String selectedPage = 'Weather';
  final String apiKey = 'd610395e85b50074b834a0234b0776db';
  TextEditingController cityController = TextEditingController();
  String city = 'Delhi';
  String temperature = '';
  String description = '';
  String iconUrl = '';
  String humidity = '';
  String windSpeed = '';
  String pressure = '';

  List<String> cities = [
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

  Future<void> fetchWeather(String inputCity) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$inputCity&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        city = inputCity;
        temperature = data['main']['temp'].toString();
        description = data['weather'][0]['description'];
        final iconCode = data['weather'][0]['icon'];
        iconUrl = 'https://openweathermap.org/img/w/$iconCode.png';
        humidity = data['main']['humidity'].toString();
        windSpeed = data['wind']['speed'].toString();
        pressure = data['main']['pressure'].toString();
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          backgroundColor: Color.fromARGB(255, 10, 95, 105),
          elevation: 10,
          actions: [
            _buildDropDown(),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 159, 213, 219),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Weather in $city',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Enter City',
                    hintText: 'e.g., New York',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return cities.where((city) =>
                      city.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  cityController.text = suggestion;
                  fetchWeather(suggestion);
                },
              ),
              ElevatedButton(
                onPressed: () => fetchWeather(cityController.text),
                child: Text('Get Weather'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Temperature',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$temperature°C',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Text(
                        'Description',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$description',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Humidity',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$humidity%',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Text(
                        'Wind Speed',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$windSpeed m/s',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Text(
                        'Pressure',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$pressure hPa',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Image.network(
                iconUrl,
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSelectedPage() {
    Navigator.pushNamed(context, "/$selectedPage");
  }

  Widget _buildDropDown() {
    return DropdownButton<String>(
      value: selectedPage,
      onChanged: (String? newValue) {
        setState(() {
          selectedPage = newValue!;
          _navigateToSelectedPage();
        });
      },
      dropdownColor: Color.fromARGB(255, 10, 95, 105),
      items: <String>['Weather', 'Forecast', 'About']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 235, 229, 229),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
