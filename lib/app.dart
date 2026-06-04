import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/dependency_injection/injection.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/pages/weather_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<WeatherBloc>()..add(WeatherInitiatedEvent()),
          ),
          BlocProvider(
            create: (_) => getIt<SavedCitiesBloc>(),
          ),
        ],
        child: const WeatherPage(),
      ),
    );
  }
}
