import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minimal_weather_app/app_assets.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/pages/weather_page.dart';
import 'package:minimal_weather_app/services/theme_data_service.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

class LoadingScreen extends StatefulWidget {
  final Future<void> Function() initialization;

  const LoadingScreen({required this.initialization, super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ThemeDataService _themeDataService = ThemeDataService();
  final WeatherService _weatherService = WeatherService('6ee8a1cb19b36cbb2dd61947cbf7942e');
  bool _isDarkMode = false;
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _loadThemeAndInitialize(); //loading theme and weather data
  }

  Future<void> _loadThemeAndInitialize() async {
    try {
      // Load theme preference
      _isDarkMode = await _themeDataService.getThemeMode();
      setState(() {}); // Update theme state

      // Fetch weather data (This will be used to pass to WeatherPage)
      String cityName = await _weatherService.getCity();
      _weather = await _weatherService.getWeather(cityName);

      // Simulate some initialization (Optional, e.g., loading assets or other tasks)
      await widget.initialization(); 

      // Debugging: Print a statement
      print("Initialization complete. Navigating to WeatherPage...");

      // Navigate to WeatherPage and pass the weather data
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WeatherPage(weather: _weather), // Pass weather data
          ),
        );
      }
    } catch (e) {
      print("Error during initialization: $e");
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
    Color backgroundColor = _isDarkMode
        ? hexToColor(AppAssets.darkBackgroundColor)
        : hexToColor(AppAssets.lightBackgroundColor);
    Color textColor = _isDarkMode
        ? hexToColor(AppAssets.darkPrimaryColor)
        : hexToColor(AppAssets.lightPrimaryColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom SVG animation
            SvgPicture.asset(
              AppAssets.mainLogo,
              width: 200,
              height: 200,
              color: textColor, // Adjust animation color based on theme
            ),
          ],
        ),
      ),
    );
  }
}
