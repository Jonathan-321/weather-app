import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather.dart';

class Weatherlink {
  final httpClient = http.Client();
  final weatherUrl = Uri.parse(
    'https://us-central1-oc-weather-25.cloudfunctions.net/weather',
  );

  Future<Weather> getWeather() async {
    try {
      print('Fetching weather data from: $weatherUrl');
      final response = await httpClient.get(weatherUrl);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
          'Error retrieving weather data: ${response.statusCode}',
        );
      }

      final jsonData = jsonDecode(response.body);

      // Find the sensor with type 45 (weather data)
      final weatherSensor = jsonData['sensors']?.firstWhere(
        (s) => s['sensor_type'] == 45,
        orElse:
            () => {
              'data': [{}],
            },
      );

      if (weatherSensor == null ||
          weatherSensor['data'] == null ||
          weatherSensor['data'].isEmpty) {
        throw Exception('No weather sensor data found');
      }

      final sensorData = weatherSensor['data'][0];
      print(
        'Found sensor data: ${sensorData['temp']}°F, ${sensorData['hum']}%, ${sensorData['wind_speed_avg_last_10_min']} mph',
      );

      final double feelsLikeTemp =
          (sensorData['thw_index'] ?? sensorData['temp'] ?? 0).toDouble();

      // Create the Weather object directly from the sensor data
      return Weather(
        temperature: (sensorData['temp'] ?? 0).round(),
        feelsLikeTemperature: feelsLikeTemp.round(),
        humidity: (sensorData['hum'] ?? 0).round(),
        windSpeed: (sensorData['wind_speed_avg_last_10_min'] ?? 0).round(),
        windDirection: getWindDirection(
          (sensorData['wind_dir_scalar_avg_last_10_min'] ?? 0).toDouble(),
        ),
        weatherCondition: determineWeatherCondition(
          temp: (sensorData['temp'] ?? 0).toDouble(),
          humidity: (sensorData['hum'] ?? 0).toDouble(),
          windSpeed: (sensorData['wind_speed_avg_last_10_min'] ?? 0).toDouble(),
          rainRate: (sensorData['rain_rate_last_in'] ?? 0).toDouble(),
        ),
        lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          (sensorData['ts'] ?? 0) * 1000,
        ),
      );
    } catch (e) {
      print('Error fetching weather data: $e');
      rethrow;
    }
  }

  String determineWeatherCondition({
    required double temp,
    required double humidity,
    required double windSpeed,
    required double rainRate,
  }) {
    if (rainRate > 0) return "rainy";
    if (humidity > 85) return "cloudy";
    if (windSpeed > 15) return "windy";
    if (temp > 85) return "sunny";
    if (temp < 40) return "cloudy";
    return "sunny";
  }

  String getWindDirection(double degrees) {
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];
    final index = ((degrees + 11.25) % 360 / 22.5).floor();
    return directions[index];
  }
}
