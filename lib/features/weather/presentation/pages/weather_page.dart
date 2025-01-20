import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/search_bar_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/temperature_unit_switch_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_error_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_initial_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_loaded_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_loading_widget.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              SizedBox(width: 16),
              if (state.status != WeatherStateStatus.error)
                TemperatureUnitSwitchWidget(
                  temperatureUnit: state.temperatureUnit,
                ),
              Spacer(),
              if (state.status == WeatherStateStatus.loaded)
                SearchBarWidget(city: state.city),
              SizedBox(width: 16),
            ],
          ),
          body: switch (state.status) {
            WeatherStateStatus.initial => const WeatherInitialWidget(),
            WeatherStateStatus.loading => const WeatherLoadingWidget(),
            WeatherStateStatus.error => WeatherErrorWidget(
                errorMessage: state.errorMessage!,
              ),
            WeatherStateStatus.loaded => WeatherLoadedWidget(
                weatherEntity: state.weatherEntity!,
                forecastEntity: state.forecastEntity!,
                temperatureUnit: state.temperatureUnit,
              ),
          },
        );
      },
    );
  }
}
