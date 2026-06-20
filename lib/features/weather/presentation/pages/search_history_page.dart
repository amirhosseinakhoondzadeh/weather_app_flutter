import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/search_history/search_history_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/widgets/search_history_tile_widget.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  State<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SearchHistoryBloc>().add(const SearchHistoryRequested());
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
      context
          .read<SearchHistoryBloc>()
          .add(const SearchHistoryNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search History')),
      body: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
        builder: (context, state) {
          switch (state.status) {
            case SearchHistoryStatus.initial:
            case SearchHistoryStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SearchHistoryStatus.error:
              return _ErrorView(
                  message: state.errorMessage ?? 'Something went wrong');
            case SearchHistoryStatus.loaded:
              if (state.entries.isEmpty) {
                return const _EmptyView();
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.entries.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.entries.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SearchHistoryTileWidget(entry: state.entries[index]);
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
            Text('🕔', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'No searches yet.\nSearch for a city to see your history here.',
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
                  .read<SearchHistoryBloc>()
                  .add(const SearchHistoryRequested()),
              child: const Text('Try again!'),
            ),
          ],
        ),
      ),
    );
  }
}
