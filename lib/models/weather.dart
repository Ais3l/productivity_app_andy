class Weather {
  final String description;
  final double temperature;

  Weather({required this.description, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature:
          json['main']['temp'] - 273.15, // Convert from Kelvin to Celsius
    );
  }
}
