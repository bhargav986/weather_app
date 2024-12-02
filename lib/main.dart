import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/forecast_model.dart';
import 'package:weather_app/weather_service.dart';
import 'weather_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeatherProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.clear(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (value) {
                      if (controller.text.isEmpty) {
                        weatherProvider.fetchWeatherByLocation();
                      } else {
                        weatherProvider.fetchWeather(controller.text);
                      }
                    },
                    textInputAction: TextInputAction.search,
                    style: GoogleFonts.lato(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        weatherProvider.fetchWeatherByLocation();
                      } else {
                        weatherProvider.fetchWeather(controller.text);
                      }
                    },
                    child: const Text('Go'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // Weather Display
                  weatherProvider.isLoading
                      ? const CircularProgressIndicator()
                      : weatherProvider.weather != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  weatherProvider.weather!.cityName,
                                  style: GoogleFonts.lato(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Weather Icon
                                SvgPicture.asset(
                                  'assets/cloudy.svg',
                                  height: 120,
                                  width: 120,
                                  // color: Colors.yellowAccent,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${weatherProvider.weather!.temperature}°C',
                                  style: GoogleFonts.lato(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  weatherProvider.weather!.description,
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                // Additional Data Cards
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildWeatherInfoCard(
                                        title: 'Humidity',
                                        value:
                                            '${weatherProvider.weather!.humidity}%',
                                        icon: Icons.water_drop),
                                    buildWeatherInfoCard(
                                        title: 'Wind',
                                        value:
                                            '${weatherProvider.weather!.windSpeed} Km/h',
                                        icon: Icons.wind_power),
                                    buildWeatherInfoCard(
                                        title: 'Feels Like',
                                        value:
                                            '${weatherProvider.weather!.feelsLike}°C',
                                        icon: Icons.thermostat),
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                // Forecast Section
                                // Hourly Forecast
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Hourly Forecast',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final forecast =
                                          weatherProvider.hourlyForecast[index];
                                      return buildHourlyForecastCard(forecast);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                // Daily Forecast
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Daily Forecast',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final forecast =
                                          weatherProvider.dailyForecast[index];
                                      return buildDailyForecastCard(forecast);
                                    },
                                  ),
                                )
                              ],
                            )
                          : const Text(
                              'No Weather data available',
                              style: TextStyle(color: Colors.white),
                            )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildHourlyForecastCard(HourlyForecast forecast) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          forecast.time,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          '${forecast.temperature}°C',
          style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          forecast.weatherCondition,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
        ),
      ],
    ),
  );
}

Widget buildDailyForecastCard(DailyForecast forecast) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          forecast.date,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
        ),
        Text(
          '${forecast.temperature}°C',
          style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
        ),
        Text(
          forecast.weatherCondition,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
        ),
      ],
    ),
  );
}

Widget buildWeatherInfoCard(
    {required String title, required String value, required IconData icon}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}
