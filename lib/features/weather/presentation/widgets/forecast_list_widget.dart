import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/utils/date_time_converter.dart';
import 'package:weather_app_flutter/features/weather/utils/weather_icon.dart';

class ForecastListWidget extends StatelessWidget {
  final ForecastEntity forecast;
  final TemperatureUnit temperatureUnit;

  const ForecastListWidget({
    required this.forecast,
    required this.temperatureUnit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8.0),
            itemCount: state.forecastEntity!.forecastDays.length,
            itemBuilder: (context, index) {
              final day = state.forecastEntity!.forecastDays[index];
              return GestureDetector(
                onTap: () => context
                    .read<WeatherBloc>()
                    .add(CurrentWeatherChanged(forecast.forecastDays[index])),
                child: Card(
                  color: Colors.white60,
                  elevation: state.weatherEntity == day ? 4 : 1,
                  margin: const EdgeInsets.all(4),
                  shadowColor: state.weatherEntity == day ? Colors.grey : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                          DateTimeConverter.getDayOfWeekAbbreviation(day.date)),
                      getWeatherIcon(day.icon, size: 2),
                      Text(
                          '${day.tempMin.toInt()}${temperatureUnit.symbol}/${day.tempMax.toInt()}${temperatureUnit.symbol}')
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
