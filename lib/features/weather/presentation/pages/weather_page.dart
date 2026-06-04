import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/pages/saved_cities_page.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/search_bar_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/temperature_unit_switch_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_error_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_initial_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_loaded_widget.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/weather_loading_widget.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  void _openSavedCities(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SavedCitiesBloc>(),
          child: const SavedCitiesPage(),
        ),
      ),
    );
  }

  void _saveCurrentCity(BuildContext context, WeatherState state) {
    final weather = state.weatherEntity!;
    context.read<SavedCitiesBloc>().add(
          SaveCityRequested(
            SavedCityEntity(
              cityName: weather.cityName,
              temperature: weather.temperature,
              description: weather.description,
              icon: weather.icon,
              unitSymbol: state.temperatureUnit.symbol,
            ),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${weather.cityName}')),
    );
  }

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
              if (state.status == WeatherStateStatus.loaded)
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  tooltip: 'Save city',
                  onPressed: () => _saveCurrentCity(context, state),
                ),
              IconButton(
                icon: const Icon(Icons.bookmarks_outlined),
                tooltip: 'Saved cities',
                onPressed: () => _openSavedCities(context),
              ),
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
