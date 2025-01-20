import 'package:flutter/material.dart';

Widget getWeatherIcon(String code, {size = 4}) => Image.network(
      'https://openweathermap.org/img/wn/$code@${size}x.png',
    );

Widget getWeatherImage(String code, {size = 4}) {
  final Color weatherColor =
      code.contains('d') ? (Color(0xFF87CEFA)) : (Color(0xFF000080));
  return Container(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          weatherColor,
          weatherColor.withAlpha(0),
        ],
        stops: [0.4, 1.0], // Where the gradient fades
        center: Alignment.center,
        radius: 0.5,
      ),
    ),
    child: getWeatherIcon(code, size: size),
  );
}
