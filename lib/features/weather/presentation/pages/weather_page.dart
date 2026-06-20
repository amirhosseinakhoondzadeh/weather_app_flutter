import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/search_history/search_history_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/pages/saved_cities_page.dart';
import 'package:weather_app_flutter/features/weather/presentation/pages/search_history_page.dart';
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
    return BlocConsumer<WeatherBloc, WeatherState>(
      // A successful search transitions loading -> loaded; pull-to-refresh skips
      // the loading state, so it doesn't re-record. Snapshot the shown weather.
      listenWhen: (previous, current) =>
          previous.status == WeatherStateStatus.loading &&
          current.status == WeatherStateStatus.loaded &&
          current.weatherEntity != null,
      listener: (context, state) {
        context.read<SearchHistoryBloc>().add(
              SearchRecorded(
                state.weatherEntity!,
                searchedAt: DateTime.now(),
              ),
            );
      },
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
              if (state.status == WeatherStateStatus.loaded &&
                  state.weatherEntity != null)
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  tooltip: 'Save city',
                  onPressed: () {
                    context
                        .read<SavedCitiesBloc>()
                        .add(CitySaved(state.weatherEntity!));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            '${state.weatherEntity!.cityName} saved',
                          ),
                        ),
                      );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: 'Saved cities',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SavedCitiesPage(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'Search history',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SearchHistoryPage(),
                  ),
                ),
              ),
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
