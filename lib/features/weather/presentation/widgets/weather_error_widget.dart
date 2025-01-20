import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String errorMessage;
  const WeatherErrorWidget({required this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    context.read<WeatherBloc>().add(CityNameCleared()),
                label: Text(
                  'Close',
                  style: TextStyle(fontSize: 16),
                ),
                icon: Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
            ),
            Spacer(),
            const Text(
              '🙈',
              style: TextStyle(fontSize: 64),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              errorMessage,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () =>
                  context.read<WeatherBloc>().add(CityNameSearchedEvent()),
              child: Text('Try again!'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
