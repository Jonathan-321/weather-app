import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../view_models/weather_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _defaultSpacer = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    // Remove the duplicate ChangeNotifierProvider here
    return Consumer<WeatherViewModel>(
      builder:
          (context, weather, _) => Scaffold(
            backgroundColor: const Color.fromARGB(255, 132, 11, 11),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: weather.refresh,
              child: Icon(MdiIcons.refresh, color: Colors.red),
            ),
            body: weather.isLoading ? _loading() : _loadedBody(weather),
          ),
    );
  }

  Widget _loading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Loading...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _loadedBody(WeatherViewModel weather) {
    return SafeArea(
      child: Stack(
        children: [
          // OC Logo in top right
          Positioned(
            top: 12,
            right: 12,
            child: Image.asset('assets/oc_logo.png', height: 40),
          ),
          // Weather content
          Column(
            children: [
              const Spacer(flex: 3),
              _weatherSymbol(weather),
              const Spacer(flex: 1),
              _temperatureWidget(weather),
              const Spacer(flex: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_windWidget(weather), _humidityWidget(weather)],
              ),
              const Spacer(flex: 3),
              Text(
                'Last Refreshed: ${_formatLastUpdated(weather.lastUpdated)}',
                style: const TextStyle(color: Colors.white70),
              ),
              _defaultSpacer,
            ],
          ),
        ],
      ),
    );
  }

  Widget _temperatureWidget(WeatherViewModel weather) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.currentTemp.toString(),
              style: const TextStyle(fontSize: 120, color: Colors.white),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14.0, left: 8.0),
              child: Text(
                '°F',
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
          ],
        ),
        Text(
          'Feels like: ${weather.feelsLike}°',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ],
    );
  }

  Widget _weatherSymbol(WeatherViewModel weather) {
    return Icon(weather.icon, size: 200, color: Colors.white);
  }

  Widget _windWidget(WeatherViewModel weather) {
    return Column(
      children: [
        Row(
          children: [
            Icon(MdiIcons.weatherWindy, size: 30, color: Colors.white),
            Text(
              weather.windDirection,
              style: TextStyle(
                fontSize: weather.windDirection.length == 1 ? 24 : 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          '${weather.windSpeed} mph',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _humidityWidget(WeatherViewModel weather) {
    return Row(
      children: [
        Icon(MdiIcons.waterOutline, size: 50, color: Colors.white),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hum',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              '${weather.humidity}%',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    return DateFormat.jm().format(lastUpdated);
  }
}
