import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/weather.dart';
import '../services/weatherlink.dart';

class WeatherViewModel extends ChangeNotifier {
  final _weatherlinkData = Weatherlink();
  Weather? _weatherData;
  String? _error;
  bool _isLoading = true;

  WeatherViewModel() {
    refresh();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get lastUpdated => _weatherData?.lastUpdated ?? DateTime.now();

  // Use the correct property names from the Weather model
  int get currentTemp => _weatherData?.temperature ?? 0;
  int get feelsLike => _weatherData?.feelsLikeTemperature ?? 0;
  int get humidity => _weatherData?.humidity ?? 0;
  int get windSpeed => _weatherData?.windSpeed ?? 0;
  String get windDirection => _weatherData?.windDirection ?? 'N';
  String get weatherCondition => _weatherData?.weatherCondition ?? 'sunny';

  IconData get icon {
    switch (weatherCondition) {
      case 'rainy':
        return MdiIcons.weatherRainy;
      case 'cloudy':
        return MdiIcons.weatherCloudy;
      case 'windy':
        return MdiIcons.weatherWindy;
      case 'sunny':
      default:
        return MdiIcons.weatherSunny;
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherData = await _weatherlinkData.getWeather();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
