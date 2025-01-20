enum TemperatureUnit {
  fahrenheit(name: 'imperial', symbol: '°F'),
  celsius(name: 'metric', symbol: '°C');

  const TemperatureUnit({
    required this.name,
    required this.symbol,
  });

  final String name;
  final String symbol;

  bool get isFahrenheit => this == TemperatureUnit.fahrenheit;
  bool get isCelsius => this == TemperatureUnit.celsius;
}
