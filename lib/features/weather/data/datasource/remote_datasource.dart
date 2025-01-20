import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/network/api_urls.dart';
import 'package:weather_app_flutter/features/weather/data/model/forecast_model.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather({required String city, String? unit});
  Future<ForecastModel> getWeatherForecast(
      {required String city, String? unit});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({
    required this.client,
  });

  Future<T> _fetchData<T>({
    required String endpoint,
    required String city,
    required T Function(Map<String, dynamic>) fromJson,
    String? unit,
  }) async {
    const String apiKey = String.fromEnvironment('API_KEY');

    final uri = Uri.parse('${ApiUrls.baseUrl}$endpoint').replace(
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': unit ?? 'imperial',
      },
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      final responseJson = json.decode(response.body);
      throw ServerException(
        code: responseJson['cod'],
        message: responseJson['message'],
      );
    }
  }

  @override
  Future<WeatherModel> getCurrentWeather(
      {required String city, String? unit}) async {
    return _fetchData(
      endpoint: ApiUrls.currentWeather,
      city: city,
      fromJson: (json) => WeatherModel.fromJson(json),
      unit: unit,
    );
  }

  @override
  Future<ForecastModel> getWeatherForecast(
      {required String city, String? unit}) async {
    return _fetchData(
      endpoint: ApiUrls.forecast,
      city: city,
      fromJson: (json) => ForecastModel.fromJson(json),
      unit: unit,
    );
  }
}
