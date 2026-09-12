import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveActivityLens', () {
    test('defaults to transfers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(activeActivityLensProvider),
        ActivityLens.transfers,
      );
    });

    test('select updates the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(activeActivityLensProvider.notifier)
          .select(ActivityLens.wanted);

      expect(container.read(activeActivityLensProvider), ActivityLens.wanted);
    });
  });
}
