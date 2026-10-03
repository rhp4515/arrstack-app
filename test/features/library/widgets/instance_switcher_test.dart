import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/library/library_instance_store.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/instance_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../support/fixtures.dart';

class _MemoryStore implements LibraryInstanceStore {
  final saved = <ServiceType, String>{};

  @override
  Future<String?> read(ServiceType type) async => saved[type];

  @override
  Future<void> write(ServiceType type, String instanceId) async =>
      saved[type] = instanceId;
}

Widget _host(List<ServiceInstance> instances, LibraryInstanceStore store) =>
    ProviderScope(
      overrides: [
        instancesProvider.overrideWith((ref) async => Ok(instances)),
        libraryInstanceStoreProvider.overrideWithValue(store),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Center(
            child: LibraryInstanceSwitcher(type: ServiceType.radarr),
          ),
        ),
      ),
    );

void main() {
  testWidgets('renders nothing without an instance', (tester) async {
    await tester.pumpWidget(_host(const [], _MemoryStore()));
    await tester.pump();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets('shows a plain label for a single instance', (tester) async {
    await tester.pumpWidget(
      _host([buildInstance(id: 'r1', name: 'Home Radarr')], _MemoryStore()),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Home Radarr'), findsOneWidget);
    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.byIcon(PhosphorIconsRegular.caretDown), findsNothing);
  });

  testWidgets('offers a dropdown for several instances and switches', (
    tester,
  ) async {
    final store = _MemoryStore();
    await tester.pumpWidget(
      _host([
        buildInstance(id: 'r1', name: 'Harivin Radarr', isDefault: true),
        buildInstance(id: 'r2', name: 'Anime Radarr'),
      ], store),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Harivin Radarr'), findsOneWidget);
    expect(find.byIcon(PhosphorIconsRegular.caretDown), findsOneWidget);

    await tester.tap(find.text('Harivin Radarr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anime Radarr').last);
    await tester.pumpAndSettle();

    expect(find.text('Anime Radarr'), findsOneWidget);
    expect(find.text('Harivin Radarr'), findsNothing);
    expect(store.saved[ServiceType.radarr], 'r2');
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LibraryInstanceSwitcher)),
    );
    expect(
      container
          .read(selectedLibraryInstanceIdProvider(ServiceType.radarr))
          .value,
      'r2',
    );
  });
}
