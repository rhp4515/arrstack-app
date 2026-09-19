import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CachedServiceSummary', () {
    test('round-trips through JSON', () {
      final summary = CachedServiceSummary(
        instanceId: 'radarr-1',
        instanceName: 'Home Radarr',
        serviceType: ServiceType.radarr,
        summaryLine: '412 movies · 3 missing',
        lastFetchedAt: DateTime.utc(2026, 9, 16, 12, 30),
      );

      final decoded = CachedServiceSummary.fromJson(summary.toJson());

      expect(decoded, summary);
    });
  });
}
