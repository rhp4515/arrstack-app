/// Main entry for the Library tab (spec §7).
///
/// Displays movies from Radarr and series from Sonarr (Sonarr coming soon).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/movie_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Default to Movies (Radarr)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies', icon: Icon(Icons.movie_outlined)),
            Tab(text: 'Series', icon: Icon(Icons.tv_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _MoviesTab(),
          _SeriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final instanceId = ref.read(selectedLibraryInstanceIdProvider(ServiceType.radarr)).value;
          if (instanceId != null) {
            context.go(RoutePaths.addMovie(instanceId));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select or configure a Radarr instance first.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MoviesTab extends ConsumerWidget {
  const _MoviesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedLibraryInstanceIdProvider(ServiceType.radarr));

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const _NoRadarrInstance()
          : Column(
              children: [
                _InstanceSelector(
                  type: ServiceType.radarr,
                  selectedId: id,
                ),
                Expanded(child: MovieGrid(instanceId: id)),
              ],
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _SeriesTab extends StatelessWidget {
  const _SeriesTab();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.tv_outlined,
      title: 'Sonarr coming soon',
      message: 'TV Series management will be available in Phase 5.',
    );
  }
}

class _NoRadarrInstance extends StatelessWidget {
  const _NoRadarrInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.movie_outlined,
      title: 'No Radarr instance',
      message: 'Configure a Radarr service in Settings to browse your movie library.',
    );
  }
}

class _InstanceSelector extends ConsumerWidget {
  const _InstanceSelector({required this.type, required this.selectedId});

  final ServiceType type;
  final String selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);

    return instancesAsync.when(
      data: (result) {
        if (result case Ok(:final value)) {
          final typed = value.where((i) => i.serviceType == type).toList();
          if (typed.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  'Instance:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: selectedId,
                  underline: const SizedBox.shrink(),
                  items: typed.map((i) {
                    return DropdownMenuItem(
                      value: i.id,
                      child: Text(i.name),
                    );
                  }).toList(),
                  onChanged: (id) => id != null
                      ? ref.read(selectedLibraryInstanceIdProvider(type).notifier).selectInstance(id)
                      : null,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
