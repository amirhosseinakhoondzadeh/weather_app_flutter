import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

class WeatherInitialWidget extends StatefulWidget {
  const WeatherInitialWidget({super.key});

  @override
  State<WeatherInitialWidget> createState() => _WeatherInitialWidgetState();
}

class _WeatherInitialWidgetState extends State<WeatherInitialWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autocorrect: false,
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Input a city name',
              ),
              onChanged: (value) =>
                  context.read<WeatherBloc>().add(CityNameChangedEvent(value)),
            ),
            SizedBox(
              height: 16,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(100, 50),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onPressed: onCityNameSubmitted,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void onCityNameSubmitted() {
    _controller.clear();

    context.read<WeatherBloc>().add(CityNameSearchedEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
