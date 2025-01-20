import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

class SearchBarWidget extends StatelessWidget {
  final String city;

  const SearchBarWidget({required this.city, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<WeatherBloc>().add(CityNameCleared()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 32,
          ),
          Text(
            city,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
