class Weather {
  final int temperature;
  final int feelsLikeTemperature;
  final int humidity;
  final int windSpeed;
  final String windDirection;
  final String weatherCondition;
  final DateTime lastUpdated;

  Weather({
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCondition,
    required this.lastUpdated,
  });

  // Add these getters
  int get currentTemp => temperature;
  int get feelsLike => feelsLikeTemperature;
}
