import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/services/time_service.dart';
import 'package:minimal_weather_app/services/weather_service.dart';
import 'package:minimal_weather_app/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool _isDarkMode = false;

  // get api key
  final _weatherService = WeatherService('6ee8a1cb19b36cbb2dd61947cbf7942e');
  Weather? _weather;

  final timeofday = const TimeChecker();
  String get time => timeofday.getDayOrNight();

  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error Fetching Weather: $e");
    }
  }

  // animations
  String getWeatherAnimation(String? mainConditon) {
    if (mainConditon == null) return AppAssets.clearDay;

    switch (mainConditon.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return AppAssets.cloudy;
      case "rain":
      case "drizzle":
      case "shower rain":
        if (time == "Daytime") {
          return AppAssets.rainyDay;
        } else {
          return AppAssets.rainyNight;
        }

      case "snow":
        return AppAssets.snowy;
      case "thunderstorm":
        return AppAssets.thunderstorm;

      default:
        if (time == "Daytime") {
          return AppAssets.clearDay;
        } else {
          return AppAssets.clearNight;
        }
    }
  }

  // initial state
  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
  }

  Color hexToColor(String hexCode) {
    String hex = hexCode.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha value if not present
    }
    return Color(int.parse('0x$hex'));
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _isDarkMode
        ? hexToColor(AppAssets.darkBackgroundColor)
        : hexToColor(AppAssets.lightBackgroundColor);
    Color textColor = _isDarkMode
        ? hexToColor(AppAssets.darkPrimaryColor)
        : hexToColor(AppAssets.lightPrimaryColor);
    Color highlightColor = _isDarkMode
        ? hexToColor(AppAssets.darkHighlightColor) 
        : hexToColor(AppAssets.lightHighlightColor);
    Color shadowColor = _isDarkMode
        ? hexToColor(AppAssets.darkShadowColor) 
        : hexToColor(AppAssets.lightShadowColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // display location icon
            SvgPicture.asset(AppAssets.locationIcon,
                color: textColor.withOpacity(0.8), width: 25),
            const SizedBox(height: 10),
            // display city name
            Text(
              _weather?.cityName ?? "Loading City",
              style: TextStyle(
                  fontFamily: "BebasNeue",
                  fontSize: 25,
                  color: textColor.withOpacity(0.8)),
            ),
            const SizedBox(height: 100),

            // Containter to apply neumorphism
            // display animation

            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: highlightColor,
                    offset: const Offset(-4.0, -4.0),
                    spreadRadius: 1,
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(4.0, 4.0),
                    spreadRadius: 1,
                    blurRadius: 15,
                  ),
                ],
                
  
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Adjust the padding value as needed
                child:
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              ),
            ),

            const SizedBox(height: 100),

            // display temprature
            Text(
                  "${_weather?.temprature.round()}°C",
                  style: TextStyle(
                      fontFamily: "BebasNeue",
                      fontSize: 50,
                      color: textColor.withOpacity(0.8)),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // sun icon
                SvgPicture.asset(AppAssets.sunIcon,
                color: textColor.withOpacity(0.8), width: 15),
                
                // toggle switch for dark and light mode
                Padding(
                padding: const EdgeInsets.all(
                    0.0), // Adjust the padding value as needed
                child:
                Switch(
                value: _isDarkMode, // The initial state (off)
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode =
                        value; // Toggle the mode when the switch is changed
                  });
                }),
                ),

                // moon icon
                SvgPicture.asset(AppAssets.moonIcon,
                color: textColor.withOpacity(0.8), width: 15),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
