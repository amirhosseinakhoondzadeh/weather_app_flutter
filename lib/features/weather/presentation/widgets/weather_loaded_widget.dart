import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/current_weather_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/forecast_list_widget.dart';

class WeatherLoadedWidget extends StatelessWidget {
  final ForecastEntity forecastEntity;
  final WeatherEntity weatherEntity;
  final TemperatureUnit temperatureUnit;

  WeatherLoadedWidget({
    required this.weatherEntity,
    required this.forecastEntity,
    required this.temperatureUnit,
    super.key,
  });

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      child: ListView(
        children: [
          CurrentWeatherWidget(
            weatherEntity: weatherEntity,
            temperatureUnit: temperatureUnit,
          ),
          ForecastListWidget(
            forecast: forecastEntity,
            temperatureUnit: temperatureUnit,
          ),
        ],
      ),
      onRefresh: () {
        context
            .read<WeatherBloc>()
            .add(CityNameSearchedEvent(isPullToRefresh: true));
        _refreshController.refreshCompleted();
      },
    );
  }
}
