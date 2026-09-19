import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeSummary holds hero counts and status lines', () {
    const summary = HomeSummary(
      healthy: 5,
      total: 6,
      statusLines: [
        HomeStatusLine(label: 'Bazarr unreachable', isWarning: true),
      ],
    );

    expect(summary.healthy, 5);
    expect(summary.total, 6);
    expect(summary.statusLines, hasLength(1));
    expect(summary.statusLines.first.isWarning, isTrue);
  });
}
