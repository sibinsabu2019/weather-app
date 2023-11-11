import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey =
    '6b3f30b796eaf1707d86fc4f75fc66aa'; // Replace with your OpenWeatherMap API key
const String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Map<String, dynamic>? weatherData;
  String cityInput = 'India';

  @override
  void initState() {
    super.initState();
    fetchWeather(cityInput);
  }

  Future<void> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$apiUrl?q=$city&appid=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    }
  }

  String getWeatherCondition() {
    return (weatherData?['weather'][0]['description'] ?? '').toLowerCase();
  }

  String getTemperatureCelsius() {
    if (weatherData != null && weatherData!['main'] != null) {
      double kelvinTemperature = weatherData!['main']['temp'];
      double celsiusTemperature = kelvinTemperature - 273.15;
      return celsiusTemperature.toStringAsFixed(2); // Limit to 2 decimal places
    } else {
      return 'N/A';
    }
  }

  String getWeatherIcon() {
    final condition = getWeatherCondition();
    if (condition == 'overcast clouds') {
      return 'assets/overcast_clouds.png';
    } else if (condition == 'clear sky') {
      return 'assets/clear_sky.png';
    } else if (condition == 'fog') {
      return 'assets/fog.png';
    } else if (condition == 'broken clouds') {
      return 'assets/broken_clouds.png';
    } else if (condition == 'scattered clouds') {
      return 'assets/scatted_clouds.png';
    } else if (condition == 'few clouds') {
      return 'assets/few_clouds.png';
    } else if (condition == 'haze') {
      return 'assets/haze.png';
    } else {
      return 'assets/haze.png'; // Use a default weather icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: weatherData == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (newCity) {
                        cityInput = newCity;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter a city',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            fetchWeather(cityInput);
                          },
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Location: ${weatherData!['name']}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Temperature: ${getTemperatureCelsius()}°C',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Weather: ${weatherData!['weather'][0]['description']}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ), // Add spacing between weather details and icon
                  Image.asset(
                    getWeatherIcon(),
                    width: 50, // Set the desired width for the weather icon
                    height: 50, // Set the desired height for the weather icon
                  ),
                ],
              ),
            ),
    );
  }
}
