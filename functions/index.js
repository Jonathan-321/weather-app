const {initializeApp} = require("firebase-admin/app");
const {onRequest} = require("firebase-functions/v2/https");
const axios = require("axios");
const cors = require('cors')({origin: true});
require('dotenv').config();

initializeApp();

const _apiKey = process.env.API_KEY;
const _secret = process.env.API_SECRET;

// Cache management
let cachedData = null;
let cacheTime = 0;
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

exports.weather = onRequest(async (req, res) => {
  return cors(req, res, async () => {
    try {
      // Set CORS headers
      res.set('Access-Control-Allow-Origin', '*');
      res.set('Access-Control-Allow-Methods', 'GET');
      res.set('Access-Control-Allow-Headers', 'Content-Type');
      
      if (req.method === 'OPTIONS') {
        res.set('Access-Control-Max-Age', '3600');
        res.status(204).send('');
        return;
      }

      const now = Date.now();
      const cacheExpired = now - cacheTime > CACHE_DURATION;
      
      let weatherData;
      
      if (cacheExpired || !cachedData) {
        weatherData = await fetchWeatherData();
        cachedData = weatherData;
        cacheTime = now;
      } else {
        weatherData = cachedData;
      }

      res.set('Cache-Control', 'no-store, no-cache, must-revalidate');
      res.json(weatherData);
      
    } catch (error) {
      console.error("Error in weather function:", error);
      res.status(500).json({ error: "Failed to fetch weather data" });
    }
  });
});

async function fetchWeatherData() {
  const stationId = await getStationId();
  const timestamp = Date.now();
  const requestUrl = `https://api.weatherlink.com/v2/current/${stationId}?api-key=${_apiKey}&_=${timestamp}`;

  const response = await axios.get(requestUrl, {
    headers: { "X-Api-Secret": _secret },
    timeout: 5000
  });

  return processWeatherData(response.data);
}

async function getStationId() {
  const response = await axios.get(
    `https://api.weatherlink.com/v2/stations?api-key=${_apiKey}`,
    {
      headers: { "X-Api-Secret": _secret },
      timeout: 3000
    }
  );
  
  if (!response.data?.stations?.[0]?.station_id) {
    throw new Error("No station ID found");
  }
  
  return response.data.stations[0].station_id;
}

function processWeatherData(data) {
  const sensorData = data.sensors?.find(s => s.sensor_type === 45)?.data?.[0]; // Specifically look for sensor_type 45
  
  if (!sensorData) {
    throw new Error("No sensor data found");
  }
  
  console.log("Processing sensor data:", JSON.stringify({
    temp: sensorData.temp,
    hum: sensorData.hum,
    wind_speed: sensorData.wind_speed_avg_last_10_min
  }));
  
  return {
    temperature: sensorData.temp,
    dewPoint: sensorData.dew_point,
    humidity: sensorData.hum,
    windSpeed: sensorData.wind_speed_avg_last_10_min,
    windDegrees: sensorData.wind_dir_scalar_avg_last_10_min,
    rainRate: sensorData.rain_rate_last_in,
    lastUpdated: new Date().toISOString()
  };
}