import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_model.dart';
import 'forecast_model.dart';
import 'weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();
  Weather? _weather;
  bool _isLoading = false;

  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];

  Weather? get weather => _weather;

  bool get isLoading => _isLoading;

  // Getters for hourly and daily forecasts
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;

  List<DailyForecast> get dailyForecast => _dailyForecast;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      var weatherData = await service.fetchWeather(city);
      print('Received weather data: $weatherData');

      if (weatherData != null) {
        _weather = weatherData;
      } else {
        print("Weather data is null or invalid for city: $city");
      }

      _hourlyForecast = []; // Populate with placeholder or process if available
      _dailyForecast = []; // Populate with placeholder or process if available
    } catch (e) {
      print("Error fetching weather data: $e");
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> fetchWeather(String city) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   _weather = await service.fetchWeather(city);
  //
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      _isLoading = false;
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied.');
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      var weatherData = await service.fetchWeatherByLocation(
          position.latitude, position.longitude);

      if (weatherData != null) {
        _weather = weatherData;

        _hourlyForecast = weatherData.hourly;
        _dailyForecast = weatherData.daily;
      } else {
        print('Weather data by location is null or invalid');
        _weather = null;
        _hourlyForecast = [];
        _dailyForecast = [];
      }
    } catch (e) {
      print('Failed to get location or weather data: $e');
      _weather = null;
      _hourlyForecast = [];
      _dailyForecast = [];
    }
  }

// Future<void> fetchWeatherByLocation() async {
//   _isLoading = true;
//   notifyListeners();
//
//   // Request permission to access location
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     print('Location services are disabled.');
//     _isLoading = false;
//     notifyListeners();
//     return;
//   }
//
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       print('Location permission denied.');
//       _isLoading = false;
//       notifyListeners();
//       return;
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     print('Location permission permanently denied.');
//     _isLoading = false;
//     notifyListeners();
//     return;
//   }
//
//   try {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     _weather = await service.fetchWeatherByLocation(
//         position.latitude, position.longitude);
//   } catch (e) {
//     print('Failed to get location: $e');
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }
}
