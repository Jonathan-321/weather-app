import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/weather_view_model.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const ocMaroon = Color.fromARGB(255, 129, 20, 41);
  static const ocDarkMaroon = Color.fromARGB(255, 72, 17, 28);
  static const ocWhite = Colors.white;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherViewModel>(
      create: (_) => WeatherViewModel(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: ocMaroon,
            secondary: ocDarkMaroon,
          ),
          iconTheme: const IconThemeData(color: ocWhite),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: ocMaroon,
            backgroundColor: ocWhite,
          ),
          scaffoldBackgroundColor: ocMaroon,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(),
          ).apply(bodyColor: ocWhite),
        ),
        home: const HomePage(),
      ),
    );
  }
}
