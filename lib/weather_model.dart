import 'forecast_model.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final List<HourlyForecast> hourly;  // New field for hourly forecast
  final List<DailyForecast> daily;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.hourly,
    required this.daily,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: '',
      temperature: json['current']['temp'],
      description: json['current']['weather'][0]['description'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_speed'],
      feelsLike: json['current']['feels_like'],
      hourly: HourlyForecast.fromJsonList(json['hourly']),
      daily: DailyForecast.fromJsonList(json['daily']),
    );
  }
}

// class ForeCast {
//   final String time;
//   final double temperature;
//   final String weatherCondition;
//
//   ForeCast({
//     required this.time,
//     required this.temperature,
//     required this.weatherCondition,
//   });
// }
//
// class WeatherData {
//   final List<ForeCast> hourlyForecast;
//   final List<ForeCast> dailyForecast;
//
//   WeatherData({
//     required this.hourlyForecast,
//     required this.dailyForecast,
//   });
// }
