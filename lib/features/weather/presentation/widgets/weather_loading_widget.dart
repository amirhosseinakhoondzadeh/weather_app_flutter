import 'package:flutter/material.dart';

class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⛅', style: TextStyle(fontSize: 64)),
          Text(
            'Loading Weather',
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
