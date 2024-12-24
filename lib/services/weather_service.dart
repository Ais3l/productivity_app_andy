import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _apiKey =
      'ea29292bd04e98717f97143a863d6f38'; // Replace with your actual API key
  static const String _defaultCity = 'Seoul'; // Set your default city here

  static Future<Weather> getWeather({String? city}) async {
    final String queryCity =
        city ?? _defaultCity; // Use default city if none provided
    final response =
        await http.get(Uri.parse('$_baseUrl?q=$queryCity&appid=$_apiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
