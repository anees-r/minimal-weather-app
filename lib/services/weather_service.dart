import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  final BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String API_KEY;

  WeatherService(this.API_KEY);

  Future<Weather> getWeather(String city) async {
    // get weather data from api service
    final response = await http.get(Uri.parse("$BASE_URL?q=$city&appid=$API_KEY&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get Weather Data!!');
    }
  }

  Future<String> getCity() async {
    // get user location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    // fetch user location

    Position position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    // turn the position into a list of placemark objects of latitude and longitude
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

   // get the city name from the placemarks
    String? city = placemarks[0].locality;

    return city ?? "";
  }

}
