import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeServiceSummary holds per-service tile data', () {
    const summary = HomeServiceSummary(
      instanceId: 'radarr-1',
      instanceName: 'Home Radarr',
      serviceType: ServiceType.radarr,
      isReachable: true,
      summaryLine: '412 movies · 3 missing',
    );

    expect(summary.instanceId, 'radarr-1');
    expect(summary.isReachable, isTrue);
    expect(summary.statusLabel, isNull);
  });

  test(
    'two summaries with the same fields are equal (freezed value equality)',
    () {
      const a = HomeServiceSummary(
        instanceId: 'radarr-1',
        instanceName: 'Home Radarr',
        serviceType: ServiceType.radarr,
        isReachable: false,
        summaryLine: 'Unreachable',
        statusLabel: 'Unreachable',
      );
      const b = HomeServiceSummary(
        instanceId: 'radarr-1',
        instanceName: 'Home Radarr',
        serviceType: ServiceType.radarr,
        isReachable: false,
        summaryLine: 'Unreachable',
        statusLabel: 'Unreachable',
      );

      expect(a, b);
    },
  );
}
