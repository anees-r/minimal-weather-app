import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/services/theme_data_service.dart';
import 'package:minimal_weather_app/services/time_service.dart';
import 'package:minimal_weather_app/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherPage extends StatefulWidget {
  final Weather? weather;

  const WeatherPage({super.key, required this.weather});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // theme mode
  bool _isDarkMode = false;
  final ThemeDataService _themeDataService = ThemeDataService();

  bool _isLoading = false; // Loading state

  final timeofday = const TimeChecker();
  String get time => timeofday.getDayOrNight();

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load saved theme preference
  }

  Future<void> _loadThemePreference() async {
    _isDarkMode = await _themeDataService.getThemeMode();
    setState(() {});
  }

  // Toggle and save theme preference
  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    await _themeDataService.saveThemeMode(_isDarkMode);
  }

  // Weather animation logic
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return AppAssets.clearDay;

    switch (mainCondition.toLowerCase()) {
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
        return time == "Daytime" ? AppAssets.rainyDay : AppAssets.rainyNight;
      case "snow":
        return AppAssets.snowy;
      case "thunderstorm":
        return AppAssets.thunderstorm;
      default:
        return time == "Daytime" ? AppAssets.clearDay : AppAssets.clearNight;
    }
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
    final weather = widget.weather; // Use the passed weather data

    if (weather == null) {
      return const Scaffold(
        body: Center(child: Text("No weather data available.")),
      );
    }

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
        child: _isLoading
            ? CircularProgressIndicator(color: textColor) // Loading indicator
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location Icon
                  SvgPicture.asset(
                    AppAssets.locationIcon,
                    color: textColor.withOpacity(0.8),
                    width: 25,
                  ),
                  const SizedBox(height: 10),
                  // City name
                  Text(
                    weather.cityName,
                    style: TextStyle(
                      fontFamily: "BebasNeue",
                      fontSize: 25,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 100),
                  // Weather Animation
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
                      padding: const EdgeInsets.all(16.0),
                      child: Lottie.asset(getWeatherAnimation(weather.mainCondition)),
                    ),
                  ),
                  const SizedBox(height: 100),
                  // Temperature
                  Text(
                    "${weather.temprature.round()}°C",
                    style: TextStyle(
                      fontFamily: "BebasNeue",
                      fontSize: 50,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sun Icon
                      SvgPicture.asset(
                        AppAssets.sunIcon,
                        color: textColor.withOpacity(0.8),
                        width: 15,
                      ),
                      // Toggle theme
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Switch(
                          value: _isDarkMode,
                          onChanged: (bool value) {
                            _toggleTheme(value);
                          },
                        ),
                      ),
                      // Moon Icon
                      SvgPicture.asset(
                        AppAssets.moonIcon,
                        color: textColor.withOpacity(0.8),
                        width: 15,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
