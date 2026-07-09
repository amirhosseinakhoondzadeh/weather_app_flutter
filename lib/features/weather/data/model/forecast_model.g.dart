// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      cod: json['cod'] as String,
      message: (json['message'] as num).toInt(),
      cnt: (json['cnt'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => ForecastList.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{
      'cod': instance.cod,
      'message': instance.message,
      'cnt': instance.cnt,
      'list': instance.list,
      'city': instance.city,
    };

ForecastList _$ForecastListFromJson(Map<String, dynamic> json) => ForecastList(
      dt: (json['dt'] as num).toInt(),
      main: Main.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      clouds: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
      wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
      visibility: (json['visibility'] as num).toInt(),
      pop: (json['pop'] as num).toDouble(),
      sys: Sys.fromJson(json['sys'] as Map<String, dynamic>),
      dt_txt: json['dt_txt'] as String,
      rain: json['rain'] == null
          ? null
          : Rain.fromJson(json['rain'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastListToJson(ForecastList instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'clouds': instance.clouds,
      'wind': instance.wind,
      'visibility': instance.visibility,
      'pop': instance.pop,
      'sys': instance.sys,
      'dt_txt': instance.dt_txt,
      'rain': instance.rain,
    };

Main _$MainFromJson(Map<String, dynamic> json) => Main(
      temp: (json['temp'] as num).toDouble(),
      feels_like: (json['feels_like'] as num).toDouble(),
      temp_min: (json['temp_min'] as num).toDouble(),
      temp_max: (json['temp_max'] as num).toDouble(),
      pressure: (json['pressure'] as num).toInt(),
      sea_level: (json['sea_level'] as num).toInt(),
      grnd_level: (json['grnd_level'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
      temp_kf: (json['temp_kf'] as num).toDouble(),
    );

Map<String, dynamic> _$MainToJson(Main instance) => <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feels_like,
      'temp_min': instance.temp_min,
      'temp_max': instance.temp_max,
      'pressure': instance.pressure,
      'sea_level': instance.sea_level,
      'grnd_level': instance.grnd_level,
      'humidity': instance.humidity,
      'temp_kf': instance.temp_kf,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      id: (json['id'] as num).toInt(),
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

Clouds _$CloudsFromJson(Map<String, dynamic> json) => Clouds(
      all: (json['all'] as num).toInt(),
    );

Map<String, dynamic> _$CloudsToJson(Clouds instance) => <String, dynamic>{
      'all': instance.all,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      speed: (json['speed'] as num).toDouble(),
      deg: (json['deg'] as num).toInt(),
      gust: (json['gust'] as num).toDouble(),
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'speed': instance.speed,
      'deg': instance.deg,
      'gust': instance.gust,
    };

Sys _$SysFromJson(Map<String, dynamic> json) => Sys(
      pod: json['pod'] as String,
    );

Map<String, dynamic> _$SysToJson(Sys instance) => <String, dynamic>{
      'pod': instance.pod,
    };

Rain _$RainFromJson(Map<String, dynamic> json) => Rain(
      volume: (json['3h'] as num).toDouble(),
    );

Map<String, dynamic> _$RainToJson(Rain instance) => <String, dynamic>{
      '3h': instance.volume,
    };

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
      country: json['country'] as String,
      population: (json['population'] as num).toInt(),
      timezone: (json['timezone'] as num).toInt(),
      sunrise: (json['sunrise'] as num).toInt(),
      sunset: (json['sunset'] as num).toInt(),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coord': instance.coord,
      'country': instance.country,
      'population': instance.population,
      'timezone': instance.timezone,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };

Coord _$CoordFromJson(Map<String, dynamic> json) => Coord(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordToJson(Coord instance) => <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
