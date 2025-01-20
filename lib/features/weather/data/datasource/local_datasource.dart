import 'package:shared_preferences/shared_preferences.dart';

const String unitKey = 'temperature_unit';

abstract class WeatherLocalDataSource {
  Future<void> saveTemperatureUnit(String unit);
  Future<String> getTemperatureUnit();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveTemperatureUnit(String unit) async {
    await sharedPreferences.setString(unitKey, unit);
  }

  @override
  Future<String> getTemperatureUnit() async {
    return sharedPreferences.getString(unitKey) ?? 'metric';
  }
}
