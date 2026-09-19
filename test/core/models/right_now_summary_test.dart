import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RightNowSummary holds throughput, counts, and segment fractions', () {
    const summary = RightNowSummary(
      downloadSpeed: 1024,
      uploadSpeed: 512,
      downloadingCount: 2,
      seedingCount: 3,
      etaToNextFinishSeconds: 120,
      downloadingFraction: 0.5,
      pausedOrStalledFraction: 0.25,
      queuedFraction: 0.25,
    );

    expect(summary.downloadSpeed, 1024);
    expect(summary.etaToNextFinishSeconds, 120);
    expect(
      summary.downloadingFraction +
          summary.pausedOrStalledFraction +
          summary.queuedFraction,
      1.0,
    );
  });

  test('etaToNextFinishSeconds is nullable', () {
    const summary = RightNowSummary(
      downloadSpeed: 0,
      uploadSpeed: 0,
      downloadingCount: 0,
      seedingCount: 0,
      downloadingFraction: 0,
      pausedOrStalledFraction: 0,
      queuedFraction: 0,
    );

    expect(summary.etaToNextFinishSeconds, isNull);
  });
}
