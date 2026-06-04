import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities_bloc.dart';
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
    // Load the first page fresh from storage (reflects any newly saved cities).
    context.read<SavedCitiesBloc>().add(SavedCitiesFetched());
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
      context.read<SavedCitiesBloc>().add(SavedCitiesNextPageFetched());
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
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.errorMessage ?? 'Something went wrong',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case SavedCitiesStatus.loaded:
            case SavedCitiesStatus.loadingMore:
              if (state.cities.isEmpty) {
                return const Center(child: Text('No saved cities yet'));
              }

              final isLoadingMore =
                  state.status == SavedCitiesStatus.loadingMore;

              return ListView.separated(
                controller: _scrollController,
                itemCount: state.cities.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(height: 1),
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
                    onDelete: () => context
                        .read<SavedCitiesBloc>()
                        .add(SavedCityDeleted(city.cityName)),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
