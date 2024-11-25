import 'package:flutter/material.dart';

class TimeChecker extends StatelessWidget {
  const TimeChecker({super.key});

  // Function to check if it's day or night based on the current time
  String getDayOrNight() {
    // Get current time
    DateTime now = DateTime.now();
    int hour = now.hour;

    // Define day time as between 6 AM and 6 PM
    if (hour >= 6 && hour < 18) {
      return "Daytime";
    } else {
      return "Nighttime";
    }
  }
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}