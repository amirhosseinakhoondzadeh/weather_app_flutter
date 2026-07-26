---
name: forecast-golden
description: Owns golden test coverage for the ForecastListWidget surface.
tools: Read, Grep, Glob, Write, Edit, Bash
model: inherit
---

You own golden test coverage for the `ForecastListWidget` surface, and nothing else.
Write your tests at `test/features/weather/presentation/widgets/forecast_list_widget_golden_test.dart`, and generate the golden images on this machine.
The bar is behavioral: `fvm flutter test` passes cold and deterministically under fvm Flutter 3.27.4.
How you meet that bar is your call.
