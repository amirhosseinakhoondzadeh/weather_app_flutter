import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late WeatherLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        WeatherLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('saveTemperatureUnit', () {
    const String unit = 'imperial';

    test('should call SharedPreferences to save the temperature unit',
        () async {
      // Arrange
      when(mockSharedPreferences.setString(unitKey, unit))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.saveTemperatureUnit(unit);

      // Assert
      verify(mockSharedPreferences.setString(unitKey, unit)).called(1);
    });

    test('should throw an exception if saving fails', () async {
      // Arrange
      when(mockSharedPreferences.setString(unitKey, unit))
          .thenThrow(Exception('Saving failed'));

      // Act & Assert
      expect(() => dataSource.saveTemperatureUnit(unit),
          throwsA(isA<Exception>()));
      verify(mockSharedPreferences.setString(unitKey, unit)).called(1);
    });
  });

  group('getTemperatureUnit', () {
    test('should return "metric" even when another unit is stored', () async {
      // Arrange
      when(mockSharedPreferences.getString(unitKey)).thenReturn('imperial');

      // Act
      final result = await dataSource.getTemperatureUnit();

      // Assert
      expect(result, 'metric');
      verifyNever(mockSharedPreferences.getString(unitKey));
    });

    test('should return "metric" if no value is saved', () async {
      // Arrange
      when(mockSharedPreferences.getString(unitKey)).thenReturn(null);

      // Act
      final result = await dataSource.getTemperatureUnit();

      // Assert
      expect(result, 'metric');
      verifyNever(mockSharedPreferences.getString(unitKey));
    });
  });
}
