import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/app.dart';
import 'package:weather_app_flutter/dependency_injection/injection.dart' as di;
import 'package:weather_app_flutter/weather_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  Bloc.observer = WeatherBlocObserver();

  runApp(const WeatherApp());
}
