import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BazarrWantedAggregate holds subtitles and the unreachable flag', () {
    const aggregate = BazarrWantedAggregate(
      subtitles: [BazarrWantedSubtitle(title: 'x')],
      hasUnreachableInstance: true,
    );

    expect(aggregate.subtitles, hasLength(1));
    expect(aggregate.hasUnreachableInstance, isTrue);
  });
}
