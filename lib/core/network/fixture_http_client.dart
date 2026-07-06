import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

/// An [http.Client] that serves bundled JSON fixtures instead of calling the
/// network. Wired in on the demo branch so the app renders deterministic
/// weather with no `API_KEY` dart-define.
///
/// Routing ignores query parameters and looks only at the request path:
/// a `/forecast` path is served from [_forecastFixture]; anything else
/// (i.e. `/weather`) from [_currentWeatherFixture].
class FixtureHttpClient extends http.BaseClient {
  static const String _currentWeatherFixture =
      'assets/fixtures/current_weather.json';
  static const String _forecastFixture = 'assets/fixtures/forecast.json';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final asset = request.url.path.contains('/forecast')
        ? _forecastFixture
        : _currentWeatherFixture;

    final body = utf8.encode(await rootBundle.loadString(asset));

    return http.StreamedResponse(
      Stream.value(body),
      200,
      request: request,
      contentLength: body.length,
      headers: const {'content-type': 'application/json; charset=utf-8'},
    );
  }
}
