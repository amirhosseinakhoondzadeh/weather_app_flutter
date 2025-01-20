// Mocks generated by Mockito 5.4.5 from annotations
// in weather_app_flutter/test/features/weather/mocks/mock_dependencies.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:convert' as _i8;
import 'dart:typed_data' as _i10;

import 'package:dartz/dartz.dart' as _i5;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i11;
import 'package:weather_app_flutter/core/error/failures.dart' as _i14;
import 'package:weather_app_flutter/core/usecase/usecase.dart' as _i19;
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart'
    as _i13;
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart'
    as _i12;
import 'package:weather_app_flutter/features/weather/data/model/forecast_model.dart'
    as _i4;
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart'
    as _i3;
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart'
    as _i16;
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart'
    as _i15;
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart'
    as _i6;
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart'
    as _i17;
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart'
    as _i18;
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart'
    as _i20;
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart'
    as _i21;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStreamedResponse_1 extends _i1.SmartFake
    implements _i2.StreamedResponse {
  _FakeStreamedResponse_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeWeatherModel_2 extends _i1.SmartFake implements _i3.WeatherModel {
  _FakeWeatherModel_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeForecastModel_3 extends _i1.SmartFake implements _i4.ForecastModel {
  _FakeForecastModel_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeEither_4<L, R> extends _i1.SmartFake implements _i5.Either<L, R> {
  _FakeEither_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeWeatherRepository_5 extends _i1.SmartFake
    implements _i6.WeatherRepository {
  _FakeWeatherRepository_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i2.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#head, [url], {#headers: headers}),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(#head, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<_i2.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#get, [url], {#headers: headers}),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(#get, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<_i2.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #post,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(
                  #post,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<_i2.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #put,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(
                  #put,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<_i2.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #patch,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(
                  #patch,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<_i2.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #delete,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i2.Response>.value(
              _FakeResponse_0(
                this,
                Invocation.method(
                  #delete,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.Response>);

  @override
  _i7.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#read, [url], {#headers: headers}),
            returnValue: _i7.Future<String>.value(
              _i9.dummyValue<String>(
                this,
                Invocation.method(#read, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  _i7.Future<_i10.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readBytes, [url], {#headers: headers}),
            returnValue: _i7.Future<_i10.Uint8List>.value(_i10.Uint8List(0)),
          )
          as _i7.Future<_i10.Uint8List>);

  @override
  _i7.Future<_i2.StreamedResponse> send(_i2.BaseRequest? request) =>
      (super.noSuchMethod(
            Invocation.method(#send, [request]),
            returnValue: _i7.Future<_i2.StreamedResponse>.value(
              _FakeStreamedResponse_1(
                this,
                Invocation.method(#send, [request]),
              ),
            ),
          )
          as _i7.Future<_i2.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
    Invocation.method(#close, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i11.SharedPreferences {
  MockSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Set<String> getKeys() =>
      (super.noSuchMethod(
            Invocation.method(#getKeys, []),
            returnValue: <String>{},
          )
          as Set<String>);

  @override
  Object? get(String? key) =>
      (super.noSuchMethod(Invocation.method(#get, [key])) as Object?);

  @override
  bool? getBool(String? key) =>
      (super.noSuchMethod(Invocation.method(#getBool, [key])) as bool?);

  @override
  int? getInt(String? key) =>
      (super.noSuchMethod(Invocation.method(#getInt, [key])) as int?);

  @override
  double? getDouble(String? key) =>
      (super.noSuchMethod(Invocation.method(#getDouble, [key])) as double?);

  @override
  String? getString(String? key) =>
      (super.noSuchMethod(Invocation.method(#getString, [key])) as String?);

  @override
  bool containsKey(String? key) =>
      (super.noSuchMethod(
            Invocation.method(#containsKey, [key]),
            returnValue: false,
          )
          as bool);

  @override
  List<String>? getStringList(String? key) =>
      (super.noSuchMethod(Invocation.method(#getStringList, [key]))
          as List<String>?);

  @override
  _i7.Future<bool> setBool(String? key, bool? value) =>
      (super.noSuchMethod(
            Invocation.method(#setBool, [key, value]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> setInt(String? key, int? value) =>
      (super.noSuchMethod(
            Invocation.method(#setInt, [key, value]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> setDouble(String? key, double? value) =>
      (super.noSuchMethod(
            Invocation.method(#setDouble, [key, value]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> setString(String? key, String? value) =>
      (super.noSuchMethod(
            Invocation.method(#setString, [key, value]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> setStringList(String? key, List<String>? value) =>
      (super.noSuchMethod(
            Invocation.method(#setStringList, [key, value]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> remove(String? key) =>
      (super.noSuchMethod(
            Invocation.method(#remove, [key]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> commit() =>
      (super.noSuchMethod(
            Invocation.method(#commit, []),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<bool> clear() =>
      (super.noSuchMethod(
            Invocation.method(#clear, []),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<void> reload() =>
      (super.noSuchMethod(
            Invocation.method(#reload, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);
}

/// A class which mocks [WeatherRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeatherRemoteDataSource extends _i1.Mock
    implements _i12.WeatherRemoteDataSource {
  MockWeatherRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i3.WeatherModel> getCurrentWeather({
    required String? city,
    String? unit,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentWeather, [], {
              #city: city,
              #unit: unit,
            }),
            returnValue: _i7.Future<_i3.WeatherModel>.value(
              _FakeWeatherModel_2(
                this,
                Invocation.method(#getCurrentWeather, [], {
                  #city: city,
                  #unit: unit,
                }),
              ),
            ),
          )
          as _i7.Future<_i3.WeatherModel>);

  @override
  _i7.Future<_i4.ForecastModel> getWeatherForecast({
    required String? city,
    String? unit,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getWeatherForecast, [], {
              #city: city,
              #unit: unit,
            }),
            returnValue: _i7.Future<_i4.ForecastModel>.value(
              _FakeForecastModel_3(
                this,
                Invocation.method(#getWeatherForecast, [], {
                  #city: city,
                  #unit: unit,
                }),
              ),
            ),
          )
          as _i7.Future<_i4.ForecastModel>);
}

/// A class which mocks [WeatherLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeatherLocalDataSource extends _i1.Mock
    implements _i13.WeatherLocalDataSource {
  MockWeatherLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> saveTemperatureUnit(String? unit) =>
      (super.noSuchMethod(
            Invocation.method(#saveTemperatureUnit, [unit]),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

  @override
  _i7.Future<String> getTemperatureUnit() =>
      (super.noSuchMethod(
            Invocation.method(#getTemperatureUnit, []),
            returnValue: _i7.Future<String>.value(
              _i9.dummyValue<String>(
                this,
                Invocation.method(#getTemperatureUnit, []),
              ),
            ),
          )
          as _i7.Future<String>);
}

/// A class which mocks [WeatherRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeatherRepository extends _i1.Mock implements _i6.WeatherRepository {
  MockWeatherRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>> getCurrentWeather(
    String? city,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentWeather, [city]),
            returnValue:
                _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>>.value(
                  _FakeEither_4<_i14.Failure, _i15.WeatherEntity>(
                    this,
                    Invocation.method(#getCurrentWeather, [city]),
                  ),
                ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>>);

  @override
  _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>> getWeatherForecast(
    String? city,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getWeatherForecast, [city]),
            returnValue:
                _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>>.value(
                  _FakeEither_4<_i14.Failure, _i16.ForecastEntity>(
                    this,
                    Invocation.method(#getWeatherForecast, [city]),
                  ),
                ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>>);

  @override
  _i7.Future<_i5.Either<_i14.Failure, void>> saveTemperatureUnit(
    String? unit,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#saveTemperatureUnit, [unit]),
            returnValue: _i7.Future<_i5.Either<_i14.Failure, void>>.value(
              _FakeEither_4<_i14.Failure, void>(
                this,
                Invocation.method(#saveTemperatureUnit, [unit]),
              ),
            ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, void>>);

  @override
  _i7.Future<_i5.Either<_i14.Failure, String>> getTemperatureUnit() =>
      (super.noSuchMethod(
            Invocation.method(#getTemperatureUnit, []),
            returnValue: _i7.Future<_i5.Either<_i14.Failure, String>>.value(
              _FakeEither_4<_i14.Failure, String>(
                this,
                Invocation.method(#getTemperatureUnit, []),
              ),
            ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, String>>);
}

/// A class which mocks [GetCurrentWeatherUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCurrentWeatherUsecase extends _i1.Mock
    implements _i17.GetCurrentWeatherUsecase {
  MockGetCurrentWeatherUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.WeatherRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeWeatherRepository_5(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i6.WeatherRepository);

  @override
  _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>> call(String? city) =>
      (super.noSuchMethod(
            Invocation.method(#call, [city]),
            returnValue:
                _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>>.value(
                  _FakeEither_4<_i14.Failure, _i15.WeatherEntity>(
                    this,
                    Invocation.method(#call, [city]),
                  ),
                ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, _i15.WeatherEntity>>);
}

/// A class which mocks [GetTemperatureUnitUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTemperatureUnitUsecase extends _i1.Mock
    implements _i18.GetTemperatureUnitUsecase {
  MockGetTemperatureUnitUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.WeatherRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeWeatherRepository_5(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i6.WeatherRepository);

  @override
  _i7.Future<_i5.Either<_i14.Failure, String>> call(_i19.NoParams? params) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i7.Future<_i5.Either<_i14.Failure, String>>.value(
              _FakeEither_4<_i14.Failure, String>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, String>>);
}

/// A class which mocks [GetWeatherForecastUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWeatherForecastUsecase extends _i1.Mock
    implements _i20.GetWeatherForecastUsecase {
  MockGetWeatherForecastUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.WeatherRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeWeatherRepository_5(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i6.WeatherRepository);

  @override
  _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>> call(
    String? city,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [city]),
            returnValue:
                _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>>.value(
                  _FakeEither_4<_i14.Failure, _i16.ForecastEntity>(
                    this,
                    Invocation.method(#call, [city]),
                  ),
                ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, _i16.ForecastEntity>>);
}

/// A class which mocks [SaveTemperatureUnitUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveTemperatureUnitUsecase extends _i1.Mock
    implements _i21.SaveTemperatureUnitUsecase {
  MockSaveTemperatureUnitUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.WeatherRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeWeatherRepository_5(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i6.WeatherRepository);

  @override
  _i7.Future<_i5.Either<_i14.Failure, void>> call(String? unit) =>
      (super.noSuchMethod(
            Invocation.method(#call, [unit]),
            returnValue: _i7.Future<_i5.Either<_i14.Failure, void>>.value(
              _FakeEither_4<_i14.Failure, void>(
                this,
                Invocation.method(#call, [unit]),
              ),
            ),
          )
          as _i7.Future<_i5.Either<_i14.Failure, void>>);
}
