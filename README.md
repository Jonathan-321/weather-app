# Weather App

A Flutter-based weather application that displays real-time weather data from a personal weather station.

## Features

- Real-time temperature, humidity, and wind data
- "Feels like" temperature calculation
- Wind direction indicator
- Weather condition icons based on current conditions
- Auto-refreshing data
- Clean, intuitive UI

## Screenshots

![Weather App Screenshot](screenshots/weather_app_screenshot.png)

## Setup Instructions

### Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- An Android or iOS device/emulator

### Installation

1. Clone the repository
   ```
   git clone https://github.com/Jonathan-321/weather-app.git
   cd weather-app
   ```

2. Create a `.env` file in the project root with the following:
   ```
   API_KEY=your_api_key_here
   API_SECRET=your_api_secret_here
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## How It Works

The app connects to a personal weather station API to fetch current weather data. It processes this raw data and displays it in a user-friendly interface.

## Platform Support

- ✅ Android
- ✅ iOS
- 🚧 Web (coming soon)

## License

This project is licensed under the MIT License - see the LICENSE file for details.