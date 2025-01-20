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
    test('should return the saved temperature unit from SharedPreferences',
        () async {
      // Arrange
      const String savedUnit = 'imperial';
      when(mockSharedPreferences.getString(unitKey)).thenReturn(savedUnit);

      // Act
      final result = await dataSource.getTemperatureUnit();

      // Assert
      expect(result, savedUnit);
      verify(mockSharedPreferences.getString(unitKey)).called(1);
    });

    test('should return the default unit "metric" if no value is saved',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(unitKey)).thenReturn(null);

      // Act
      final result = await dataSource.getTemperatureUnit();

      // Assert
      expect(result, 'metric');
      verify(mockSharedPreferences.getString(unitKey)).called(1);
    });
  });
}
