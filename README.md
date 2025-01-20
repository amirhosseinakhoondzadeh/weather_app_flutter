# Flutter Weather App Sample

## Description

A Flutter project which showcase the connection to [openweathermap](https://openweathermap.org/api) to fetch the weather condition of the given city and its forecast, following Clean Architecture principles.

## Table of Contents

- [Description](#description)
- [Project Setup and Installation](#project-setup-and-installation)
- [Application Structure and Features](#application-structure-and-features)
- [Usage Instructions](#usage-instructions)
- [Testing](#testing)
- [Dependencies](#dependencies)
- [Code Documentation](#code-documentation)

## Project Setup and Installation

### Prerequisites

- Flutter 3.27.1 • channel stable
- Dart 3.6.0
- Xcode (updated version recommended)

### Installation Steps and Running the Project

1- Install flutter and add it in your path.

2- Execute `flutter clean`,` flutter pub get`.

3- Execute `dart pub run build_runner build --delete-conflicting-outputs`

4- Execute `flutter run --dart-define=API_KEY={YOUR_API_KEY}`

### Application Structure and Features

This project follows the [Clean Architecture]("https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html") principles, separating the code into different layers:

Presentation: Contains Flutter widgets and state management (using Bloc).

Domain: Contains business logic and entities.

Data: Handles data retrieval and storage, including API calls and local storage.

#### Key Features

Fetching weather condition and forecast for the give city name.

Handle errors and failures.

selection of the forecast.

#### Bonuses

Handling nested Vertical and Horizontal Scrollable layouts.

Changing the temperature unit will update the result.

### Testing

#### Running Unit Tests

To run unit tests, execute:

```sh
flutter test
```

#### Running Unit Tests with coverage

To the tests with coverage, execute:

```sh
flutter test --coverage
```

This command runs the tests and generates a coverage report in the coverage directory.

#### View Coverage Report

The coverage report is generated in a lcov.info file located inside the coverage directory. To view this report in a more readable format, you can use an HTML report generator like lcov.

```sh
brew install lcov
```

Run the following commands to generate and view the HTML report:

```sh
genhtml coverage/lcov.info -o coverage/html
```

This command converts the lcov.info file into an HTML report and places it in the coverage/html directory.

Open the HTML report in your browser:

```sh
open coverage/html/index.html
```

### Dependencies

[dartz]("https://pub.dev/packages/dartz"): Functional programming in Dart.

[equatable]("https://pub.dev/packages/equatable"): Simplifies equality comparisons.

[flutter_bloc]("https://pub.dev/packages/flutter_bloc"): State management.

[get_it]("https://pub.dev/packages/get_it"): Dependency injection.

[http]("https://pub.dev/packages/http"): HTTP requests.

[shared_preferences]("https://pub.dev/packages/shared_preferences"): Local storage.

[mockito]("https://pub.dev/packages/mockito"): mock framework to facilitate tests.

[build_runner]("https://pub.dev/packages/build_runner"): code generation in Dart

### Demo

![App Demo 1](First-demo.webm)
![App Demo 2](Second-Demo.webm)
