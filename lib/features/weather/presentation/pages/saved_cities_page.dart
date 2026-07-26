import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/saved_city_tile_widget.dart';

class SavedCitiesPage extends StatefulWidget {
  const SavedCitiesPage({super.key});

  @override
  State<SavedCitiesPage> createState() => _SavedCitiesPageState();
}

class _SavedCitiesPageState extends State<SavedCitiesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SavedCitiesBloc>().add(const SavedCitiesRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SavedCitiesBloc>().add(const SavedCitiesNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Cities')),
      body: BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
        builder: (context, state) {
          switch (state.status) {
            case SavedCitiesStatus.initial:
            case SavedCitiesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SavedCitiesStatus.error:
              return _ErrorView(message: state.errorMessage ?? 'Something went wrong');
            case SavedCitiesStatus.loaded:
              if (state.cities.isEmpty) {
                return const _EmptyView();
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.cities.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.cities.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final city = state.cities[index];
                  return SavedCityTileWidget(
                    city: city,
                    onRemove: () => context
                        .read<SavedCitiesBloc>()
                        .add(SavedCityRemoved(city.cityName)),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🏙️', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'No saved cities yet.\nSave a city from the weather screen to see it here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🙈', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<SavedCitiesBloc>()
                  .add(const SavedCitiesRequested()),
              child: const Text('Try again!'),
            ),
          ],
        ),
      ),
    );
  }
}
