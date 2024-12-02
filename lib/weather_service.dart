import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  final String apiKey = '1c25928b1836331a06bfd4d131fae265';

  Future<Weather?> fetchWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      print('Failed to load weather data');
      return null;
    }
  }

  Future<Weather?> fetchWeatherByLocation(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&exclude=minutely,alerts&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      print('Failed to load weather data by location');
      return null;
    }
  }
}
