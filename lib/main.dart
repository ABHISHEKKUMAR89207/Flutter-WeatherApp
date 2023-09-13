import 'package:flutter/material.dart';
import 'package:weatherapp/WeatherReport.dart';
import 'package:weatherapp/about.dart';
import 'package:weatherapp/weatherforecast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Full Screen Pages',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
      routes: {
        '/page1': (context) => WeatherPage(),
        '/Forecast': (context) => ForecastPage(),
        '/About': (context) => AboutPage(),
        '/page4': (context) => Page4(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedPage = '/page1'; // Initial page selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Pages App'),
        actions: [
          _buildDropDown(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Page:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              selectedPage,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSelectedPage() {
    Navigator.pushNamed(context, selectedPage);
  }

  Widget _buildDropDown() {
    return DropdownButton<String>(
      value: selectedPage,
      onChanged: (String? newValue) {
        setState(() {
          selectedPage = newValue!;
          _navigateToSelectedPage(); // Navigate to the selected page directly
        });
      },
      items: <String>['Wether', 'Forecast', 'About']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 20, color: const Color.fromARGB(255, 16, 15, 15)),
              ),
            ),
          )
          .toList(),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Center(
        child: Text(
          'This is Page 2 in full screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Center(
        child: Text(
          'This is Page 3 in full screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 4'),
      ),
      body: Center(
        child: Text(
          'This is Page 4 in full screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
