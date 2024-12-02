class HourlyForecast {
  final String time;
  final double temperature;
  final String weatherCondition;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCondition,
  });

  // Factory method to parse JSON data
  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000).toLocal().toString(),
      temperature: json['temp'].toDouble(),
      weatherCondition: json['weather'][0]['description'],
    );
  }

  // Method to parse a list of hourly data
  static List<HourlyForecast> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HourlyForecast.fromJson(json)).toList();
  }
}

class DailyForecast{
  final String date;
  final double temperature;
  final String weatherCondition;

  DailyForecast({
    required this.date,
    required this.temperature,
    required this.weatherCondition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
          .toLocal()
          .toString(),
      temperature: json['temp']['day'].toDouble(),
      weatherCondition: json['weather'][0]['description'],
    );
  }

  static List<DailyForecast> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DailyForecast.fromJson(json)).toList();
  }
}
